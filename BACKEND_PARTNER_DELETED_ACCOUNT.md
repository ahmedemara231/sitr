# Backend requirements: deleted chat partner

## Goal

When a room member deletes their account, the other participant must still be
able to open the chat history, but the chat becomes read-only and the app
explains why.

## Mobile API contract

Add `is_partner_deleted_account` to every member object inside `room.members`:

```json
{
  "room": {
    "id": 123,
    "members": [
      {
        "id": 456,
        "name": "Partner name",
        "image": null,
        "user_type": "individual",
        "is_partner_deleted_account": true
      }
    ]
  }
}
```

- Location: `room.members[*].is_partner_deleted_account`
- Type: JSON boolean (`true` or `false`), not `0`, `1`, a string, or `null`
- Default: `false`
- `true`: that member's account has been deleted
- `false`: that member's account is active

Return the field through the shared room-member serializer/resource in every
API response containing a room, especially:

- `POST /start-chat`
- Current and previous chat-list responses
- Chat action responses that return the updated room

Do not return this field in the authenticated user/profile resource. The mobile
app identifies the member matching the chat receiver ID and reads the flag from
that member. If only the other participant is returned in `room.members`, it
uses that single member as a safe fallback.

## Account-deletion flow

After the account-deletion transaction succeeds:

1. Keep the match, room, and existing messages available to the remaining
   participant as read-only history.
2. Include the deleted member by querying room relationships with soft-deleted
   users and return `is_partner_deleted_account: true` on that member.
3. Emit the existing `update-chat` socket event to the remaining participant's
   room/user channel after the transaction commits. The mobile app will then
   request `POST /start-chat` again and receive the updated member flag.
4. Do not send further chat or call notifications to the deleted account.

Return a stable member ID and a safe display snapshot or placeholder for the
deleted member so the remaining participant can still open the conversation.

## Server-side enforcement

The mobile app hides the composer and audio/video call actions when the member
flag is `true`, but the backend must enforce the same rule. Reject attempts
involving a deleted participant for:

- Socket `send-message` events, including text and image messages
- Audio/video call invitations and video-call request endpoints
- Any endpoint that creates a new chat request with the deleted account

Return the normal API error envelope with a stable machine-readable error code,
for example `partner_account_deleted`, and an HTTP status appropriate to the
existing API convention (recommended: `409 Conflict` or `422 Unprocessable
Entity`). Do not create messages, notifications, call records, or payment
records for a rejected action.

`POST /start-chat` must continue returning the existing room and message
history. It must not reactivate or recreate the deleted account.

## Acceptance cases

1. Active member: room responses return
   `"is_partner_deleted_account": false`; chat and calls work normally.
2. Deleted member: room responses return
   `"is_partner_deleted_account": true`; history opens, while new messages and
   calls are rejected.
3. Deletion while chat is open: the remaining participant receives
   `update-chat`; the refreshed `POST /start-chat` response contains `true`, and
   no app restart or re-login is needed.
4. Every member object returns a non-null boolean value.
5. Repeated API requests or socket retries cannot create a message or call
   after the member has been deleted.
