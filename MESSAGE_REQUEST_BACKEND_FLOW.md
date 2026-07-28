# Message Request Backend Flow

This document is the backend contract used by the Flutter application for
requesting a conversation. It replaces the old flow where `start-chat`
created a pending room and the mobile app sent an initial socket message.

## Required behavior

- Sending a request creates a `message_request` only.
- Sending a request must not create a room, match request, chat, or socket
  message.
- Pending message requests must never be returned by `chats/current`.
- Accepting a pending message request creates the room and active match
  request in one database transaction.
- After acceptance, the new chat is returned by `chats/current` for both
  participants.
- A user who already has a current chat cannot accept another message request.
  They can accept again only after the current chat moves to `completed`,
  `rejected`, `cancelled`, or any other non-current status.

The authenticated user must always be taken from the bearer token. IDs in the
request body are relationship identifiers and must never be trusted as the
authenticated user.

## Endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| `POST` | `check-chat-eligibility` | Revalidate whether the sender may send a request. |
| `POST` | `send_message_request` | Create one pending message request. |
| `GET` | `message_requests?page={page}` | List pending requests received by the authenticated user. |
| `POST` | `accept_message_request` | Accept a request and atomically create the current chat. |
| `POST` | `reject_message_request` | Reject a request without creating a chat. |
| `GET` | `chats/current` | Return accepted/current chats only. |
| `POST` | `start-chat` | Return the already accepted current chat; it must no longer create pending requests. |

All responses use the existing wrapper:

```json
{
  "key": "success",
  "msg": "Operation completed successfully",
  "data": {}
}
```

## 1. Send a message request

The app first calls the existing eligibility endpoint:

```http
POST check-chat-eligibility
Authorization: Bearer <sender-token>
Content-Type: application/json

{
  "receiver_id": "42",
  "from_home": "1"
}
```

When allowed:

```json
{
  "key": "success",
  "msg": "Eligible",
  "data": {
    "can_chat": true,
    "reason": null
  }
}
```

The app then creates the request:

```http
POST send_message_request
Authorization: Bearer <sender-token>
Content-Type: application/json

{
  "receiver_id": "42"
}
```

Required server work:

1. Re-run every eligibility rule on the server. Do not rely only on the
   previous `check-chat-eligibility` response.
2. Reject self-requests, blocked users, invalid/inactive users, invalid gender
   combinations, active chats, and any other existing business restriction.
3. Prevent duplicate pending requests for the same directional
   `sender_id`/`receiver_id` pair with a database constraint or transaction.
4. Create one row with at least:
   `id`, `sender_id`, `receiver_id`, `status = pending`, `created_at`, and
   `updated_at`.
5. Do not create a room or match request.
6. Send the receiver a `message_request` push notification after the database
   transaction commits.

Successful response:

```json
{
  "key": "success",
  "msg": "Message request sent",
  "data": {
    "can_chat": false,
    "reason": "chat_request_sent"
  }
}
```

After this succeeds, both `opportunity-profile/{receiver_id}` and
`check-chat-eligibility` must persistently return:

```json
{
  "can_chat": false,
  "reason": "chat_request_sent"
}
```

Recommended conflict response for a duplicate:

```http
409 Conflict
```

```json
{
  "key": "error",
  "message": "A pending message request already exists",
  "code": "message_request_already_pending"
}
```

## 2. List received requests

```http
GET message_requests?page=1
Authorization: Bearer <receiver-token>
```

Only requests where the authenticated user is `receiver_id` and the status is
`pending` are returned. Sort newest first.

The Flutter mapper expects this exact data shape:

```json
{
  "key": "success",
  "msg": "Message requests",
  "data": {
    "message_requests": {
      "data": [
        {
          "id": 91,
          "status": "pending",
          "created_at": "2026-07-27T12:30:00Z",
          "can_accept": true,
          "accept_block_reason": null,
          "sender": {
            "id": 42,
            "name": "User name",
            "nick_name": "Display name",
            "avatar": "https://example.com/avatar.jpg",
            "age": 29,
            "city": "Riyadh",
            "is_promoted": false
          }
        }
      ],
      "pagination": {
        "per_page": 10,
        "total_pages": 1,
        "current_page": 1,
        "total_items": 1
      }
    }
  }
}
```

`can_accept` is `false` when the authenticated receiver already has a current
chat. In that case use:

```json
{
  "can_accept": false,
  "accept_block_reason": "active_current_chat"
}
```

This field improves the UI, but it does not replace server validation in the
accept endpoint.

## 3. Accept a message request

```http
POST accept_message_request
Authorization: Bearer <receiver-token>
Content-Type: application/json

{
  "message_request_id": 91,
  "sender_id": 42
}
```

The server must perform the following in one database transaction:

1. Lock the message request row.
2. Verify the authenticated user is its receiver.
3. Verify its status is still `pending`.
4. Verify `sender_id` matches the request row.
5. Lock/check the current-chat state for both participants.
6. Reject acceptance if either participant has another chat whose chat status
   is `current`.
7. Create exactly one room and its initial match request using the existing
   active-chat schema.
8. Mark the message request `accepted`, linking it to the new `room_id` and
   `match_request_id`.
9. Commit, then notify both clients that their chat lists changed.

The response data must be the existing `ChatModel` JSON consumed by the app:

```json
{
  "key": "success",
  "msg": "Message request accepted",
  "data": {
    "room": {
      "id": 501,
      "members": []
    },
    "match_request": {
      "id": 601
    }
  }
}
```

The full `room`, `members`, `match_request`, stage, timer, and status fields
must follow the current `ChatModel` contract.

If a current chat blocks acceptance:

```http
409 Conflict
```

```json
{
  "key": "error",
  "message": "Finish the current chat before accepting another request",
  "code": "active_current_chat_exists"
}
```

Concurrent accept calls must not create multiple rooms. Use row locking and
database uniqueness rules so one request can produce at most one active chat.
An idempotent retry may return the already-created chat when the same receiver
accepted the same request.

## 4. Reject a message request

```http
POST reject_message_request
Authorization: Bearer <receiver-token>
Content-Type: application/json

{
  "message_request_id": 91,
  "sender_id": 42
}
```

Required server work:

- Verify the authenticated user owns the received request.
- Verify `sender_id` matches.
- Change `pending` to `rejected`.
- Do not create a room or match request.
- Recalculate the sender's future eligibility according to business rules.

Example response:

```json
{
  "key": "success",
  "msg": "Message request rejected",
  "data": {}
}
```

## 5. Current chats and `start-chat`

`GET chats/current` must query chat/match records whose chat status is exactly
`current`. It must not join pending message requests into the chat list.

After `accept_message_request` succeeds, the created room must appear in
`chats/current` for both users. Remaining pending requests may still appear in
`message_requests`, but their `can_accept` value is false until the current chat
changes to a non-current status.

The Flutter `ChatScreen` still calls `POST start-chat` when it opens.
`start-chat` must now be idempotent and must only return the accepted current
room between the authenticated user and `receiver_id`. It must not:

- create a pending request;
- create a second room;
- send an initial message;
- make an unaccepted request visible in `chats/current`.

If no accepted current room exists, return a validation/conflict error instead
of creating one.

## 6. Push notification payload

Use a notification type understood by the app:

```json
{
  "type": "message_request",
  "message_request_id": "91",
  "message_request_status": "pending",
  "sender_id": "42",
  "sender_name": "Display name"
}
```

The action buttons call the same `accept_message_request` and
`reject_message_request` endpoints. Tapping the notification itself opens the
Connection Requests tab.

## Old behavior to remove from the server

- Do not create a room in `send_message_request` or
  `check-chat-eligibility`.
- Do not use `start-chat` to create a pending first-stage request.
- Do not require an initial socket chat message to represent a request.
- Do not put pending requests in `chats/current` for either user.
- Do not use `accept-request/{user_request}` or `reject-match-request` for the
  initial conversation request. Those endpoints remain only for later chat
  stage workflows where they are still needed.
