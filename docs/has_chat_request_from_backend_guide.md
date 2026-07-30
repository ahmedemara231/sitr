# Backend Guide: Incoming Chat Request on User Profiles

## Objective

The partner-profile screen must know whether the authenticated user has a
pending incoming chat request from the profile being viewed. When such a
request exists, the app shows **Accept** and **Reject** actions instead of the
normal chat button.

Add the following boolean to every user/profile payload consumed by
`UserModel`:

```json
{
  "has_chat_request_from": true
}
```

## Required profile response

Endpoint:

```text
GET opportunity-profile/{user_id}
```

Example:

```json
{
  "key": "success",
  "msg": "Profile loaded successfully",
  "data": {
    "id": 42,
    "name": "User name",
    "has_chat_request_from": true
  }
}
```

`has_chat_request_from` must:

- always be a JSON boolean, never `0`, `1`, `null`, or a string;
- be `true` only when the viewed user is the sender of a currently pending
  incoming message request for the authenticated user;
- be `false` when no matching pending request exists, including after that
  request is accepted, rejected, cancelled, or expired;
- be calculated for the authenticated viewer and never stored as a global
  property of the viewed user;
- default to `false` for unauthenticated responses or when the relationship
  cannot be resolved safely.

Recommended relationship check:

```text
message_requests.sender_id = viewed_user_id
message_requests.receiver_id = authenticated_user_id
message_requests.status = pending
```

Use the project's actual pending-status value if it differs from `pending`.

## Accept and reject endpoint compatibility

The profile response exposes only the sender user and the boolean flag, not a
message-request ID. Therefore these existing endpoints must continue to
support their current request-list payload and also accept a sender-only
payload from the profile:

```text
POST accept_message_request
POST reject_message_request
```

Existing request-list payload:

```json
{
  "message_request_id": 91,
  "sender_id": 42
}
```

Profile payload:

```json
{
  "sender_id": 42
}
```

For the sender-only payload, resolve the request using the authenticated user
as the receiver, the supplied `sender_id`, and pending status. Never accept a
receiver ID from the client.

The action must fail with a controlled validation response when:

- no matching pending request exists;
- multiple matching pending requests exist and the backend cannot resolve the
  canonical request safely;
- the request does not belong to the authenticated receiver;
- the request is no longer actionable.

After a successful accept or reject, a fresh
`GET opportunity-profile/{sender_id}` response must return:

```json
{
  "has_chat_request_from": false
}
```

## Security and performance

- Scope every lookup to the authenticated receiver.
- Apply the same eligibility and state-transition validation used by the
  message-requests screen.
- Keep accept/reject operations transactional to prevent double handling.
- Add or verify an index covering sender, receiver, and status so profile
  loading does not introduce an unbounded request lookup.

## Backend acceptance checklist

- Profile with a pending incoming request returns `true`.
- Profile without one returns `false`.
- An outgoing request to the viewed user still returns `false`.
- A request belonging to another receiver returns `false`.
- Accepted, rejected, cancelled, and expired requests return `false`.
- Accept and reject work with both the existing request-ID payload and the
  sender-only profile payload.
- Re-fetching the profile after either action returns `false`.
