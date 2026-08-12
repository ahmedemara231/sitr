# Backend Guide: Require Complete Registration Before Chat Requests

## Objective

A user may send a chat request only when the authenticated sender has completed
registration **and** passes every existing chat-eligibility rule.

The required rule is:

```text
can_send_chat_request =
    authenticated_user.complete_registration == true
    AND passes_all_existing_chat_eligibility_checks
```

Do not trust a registration value supplied by the mobile app. Read it from the
authenticated user's server-side record.

> **Field-name note:** the mobile API models use `complete_registration`.
> `complete_registeration` is a spelling mistake. If the database has a legacy
> column with that spelling, map it internally, but keep the API/business name
> as `complete_registration`.

## Current mobile flow

The flow starts in:

```text
lib/src/core/widgets/chat_button.dart
```

The mobile app makes two requests in this order:

```text
1. POST check-chat-eligibility
2. POST send_message_request   (only when step 1 returns can_chat = true)
```

The eligibility endpoint must not create a chat request. It is a read/check
operation. The second endpoint performs the actual write.

## Step 1: Check chat eligibility

Endpoint:

```text
POST check-chat-eligibility
```

Request body:

```json
{
  "receiver_id": "42",
  "from_home": "1"
}
```

The sender must come from the authentication token/session. Never accept a
`sender_id` or `complete_registration` value from this request body.

### Required server logic

Use the following framework-neutral logic:

```text
sender = authenticatedUser()
receiver = findUser(request.receiver_id)

if sender.complete_registration != true:
    return eligible(false, "incomplete_registration")

result = runExistingChatEligibilityChecks(sender, receiver)

if result.failed:
    return eligible(false, result.reason)

return eligible(true, null)
```

`complete_registration` must be an explicit true boolean value. Null, false,
an empty value, or an incomplete registration state must all fail.

### Existing checks must remain

The complete-registration condition is an additional `AND` condition. Do not
remove or weaken existing rules such as:

- sender and receiver must be different users;
- sender and receiver accounts must be active and approved;
- neither user may have blocked the other;
- parent/child chat restrictions;
- same-gender restrictions;
- active matches or chats with another user;
- parent-approval requirements;
- duplicate or already-sent chat requests;
- active-package requirements;
- any other current business or safety rule.

### Eligible response

Return the response shape already parsed by the mobile `CanChat` model:

```json
{
  "key": "success",
  "msg": "The user can send a chat request.",
  "data": {
    "can_chat": true,
    "reason": null
  }
}
```

### Incomplete-registration response

An ineligible result is a valid eligibility response, so return HTTP `200`
with `can_chat: false`:

```json
{
  "key": "success",
  "msg": "Complete registration before sending a chat request.",
  "data": {
    "can_chat": false,
    "reason": "incomplete_registration"
  }
}
```

The current app safely maps an unknown eligibility reason to its generic
`has_problem` state. If the product requires a specific translated button
message for incomplete registration, the mobile app must separately add
`incomplete_registration` to `ChatReason` and its locale files.

Do not return `can_chat: true` with an error message. The mobile app uses the
boolean to decide whether it should call `send_message_request`.

## Step 2: Send the chat request

Endpoint:

```text
POST send_message_request
```

Request body:

```json
{
  "receiver_id": "42"
}
```

This endpoint must repeat the complete-registration and existing eligibility
checks. Do not rely only on the earlier `check-chat-eligibility` call because:

- another client can call `send_message_request` directly;
- the sender or receiver state can change between the two requests;
- two requests can be submitted concurrently.

Recommended transaction flow:

```text
begin transaction

sender = authenticatedUserForUpdate()
receiver = findUserForUpdate(request.receiver_id)

if sender.complete_registration != true:
    rollback and return failure("incomplete_registration")

result = runExistingChatEligibilityChecks(sender, receiver)

if result.failed:
    rollback and return failure(result.reason)

create exactly one pending chat/message request
commit

return success
```

Use the project's locking or unique-constraint strategy to prevent duplicate
pending requests.

### Successful send response

```json
{
  "key": "success",
  "msg": "Chat request sent successfully.",
  "data": {
    "can_chat": false,
    "reason": "chat_request_sent"
  }
}
```

### Direct-send failure response

If an incomplete user bypasses the eligibility endpoint and calls the send
endpoint directly, create no request and return a controlled failure. HTTP
`409 Conflict` is compatible with the current mobile network error handler:

```json
{
  "key": "incomplete_registration",
  "message": "Complete registration before sending a chat request.",
  "data": null
}
```

Use `message` for HTTP error responses because that is the field read by the
mobile error handler. Do not return a `500` response for this business rule.

## Consistency with profile responses

User/profile endpoints currently provide a `can_chat` object used to render
the initial chat-button state. Calculate that value with the same shared
eligibility service so an incomplete sender does not initially see an enabled
button.

Keep one server-side eligibility function and call it from:

```text
check-chat-eligibility
send_message_request
profile/opportunity serializers that return can_chat
```

The send endpoint must still enforce the rule even when the profile and check
responses already returned `can_chat: true`.

## Acceptance checklist

- A sender with `complete_registration == true` who passes all other checks
  receives `can_chat: true`.
- A sender with `complete_registration == false` receives `can_chat: false`
  and no chat request is created.
- A sender with null or missing completion state receives `can_chat: false`.
- A completed sender who fails another existing rule still receives
  `can_chat: false` with the existing reason.
- Directly calling `send_message_request` as an incomplete sender fails and
  creates no database record.
- Changing the sender to incomplete between the check and send calls causes
  the send call to fail.
- Concurrent duplicate sends create at most one pending request.
- The server derives the sender from authentication and ignores forged sender
  or registration values.
- Successful creation returns a response compatible with `CanChat`.
- Failure responses never expose another user's private registration data.

