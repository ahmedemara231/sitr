# App Badge Counts Backend API

This document requests one aggregated backend endpoint for all badge numbers
shown in the app's bottom navigation.

The app currently uses two separate endpoints:

- `GET count-notifications`
- `GET count-unread-messages`

The Connection Requests tab also needs a count for pending incoming message
requests. Adding only `GET message_requests_count` would make the app perform
three requests every time the home screen starts or refreshes.

## Recommended solution

Create one endpoint that returns all three counts:

```http
GET app-badge-counts
Authorization: Bearer <token>
Accept: application/json
```

This endpoint replaces three client requests with one request:

```text
count-notifications
count-unread-messages
message_requests_count
                ↓
GET app-badge-counts
```

## Required response

Use the existing application response wrapper:

```json
{
  "key": "success",
  "msg": "Badge counts retrieved successfully",
  "data": {
    "notifications_count": 4,
    "unread_messages_count": 7,
    "message_requests_count": 2
  }
}
```

All three fields are required and must always be non-negative integers. Return
`0` when there are no matching records; do not return `null` and do not omit a
field.

## Count definitions

### `notifications_count`

This value must use exactly the same business rules as the existing:

```http
GET count-notifications
```

It should represent the authenticated user's unread notifications. Deleted or
already-read notifications must not be counted.

### `unread_messages_count`

This value must use exactly the same business rules as the existing:

```http
GET count-unread-messages
```

It should be the total number of unread chat messages for the authenticated
user across the chats where that user is a member.

Messages sent by the authenticated user must not be counted as unread for that
same user.

### `message_requests_count`

This value is the number of pending message requests received by the
authenticated user:

```text
message_requests.receiver_id = authenticated_user.id
AND message_requests.status = "pending"
```

Do not count:

- requests sent by the authenticated user;
- accepted requests;
- rejected requests;
- cancelled requests;
- expired or soft-deleted requests.

The count must match the pending records returned by:

```http
GET message_requests?page=1
```

Having a current chat may make a pending request temporarily unavailable for
acceptance, but that request is still pending and should remain included in
`message_requests_count` while it remains visible in `message_requests`.

## Authentication and security

- Resolve the user only from the bearer token.
- Do not accept a `user_id` query parameter or body field.
- Return `401 Unauthorized` for an invalid or expired token.
- Apply the same tenant, account-status, and soft-delete filters used by the
  existing count endpoints.

## Query and performance requirements

The endpoint is read-only and must not mark notifications or messages as read.

The backend may calculate the three values with independent subqueries, a
single statement with subqueries, or parallel repository calls. The important
mobile requirement is that all values are returned through one HTTP request.

Recommended database indexes:

```text
notifications(user_id, read_at, deleted_at)
messages(receiver_id, read_at, deleted_at)
message_requests(receiver_id, status, deleted_at)
```

Use the actual ownership/read columns from the current schema when their names
differ.

Avoid loading full records into application memory. Each value should be
calculated with a database `COUNT`.

## Consistency

The three values should represent the same request-time snapshot as closely as
the database supports. Exact cross-table transaction locking is not required
for this read-only endpoint, but the backend should not return cached values
that remain stale after:

- a notification is read or deleted;
- a chat message is read;
- a message request is sent to the user;
- a message request is accepted, rejected, cancelled, or expired.

If server-side caching is used, invalidate it for those events or keep the TTL
very short.

## Mobile refresh events

The mobile app can call `app-badge-counts`:

1. after authentication;
2. when the Home screen starts;
3. when the app returns to the foreground;
4. after receiving a relevant push notification;
5. after reading/deleting notifications;
6. after reading chat messages;
7. after accepting or rejecting a message request.

Push payloads may still be used for immediate local badge updates, but this
endpoint remains the source of truth.

## Backward-compatible rollout

Recommended rollout order:

1. Add `GET app-badge-counts`.
2. Keep `count-notifications` and `count-unread-messages` working temporarily.
3. Update the mobile app to consume the aggregate endpoint.
4. Monitor the new endpoint in production.
5. Deprecate and later remove the two old endpoints when no supported client
   version uses them.

The old endpoints and the aggregate endpoint must use shared query/service
logic during migration so their values cannot disagree.

## Error response

Use the existing API error shape. Example:

```json
{
  "key": "error",
  "message": "Unable to retrieve badge counts",
  "code": "badge_counts_unavailable"
}
```

Do not return a successful response with fabricated zero values when a
database query fails.

## Acceptance tests

The backend implementation is complete when all of these scenarios pass:

1. A user with no unread data receives three zero values.
2. One unread notification increments only `notifications_count`.
3. One unread received chat message increments only
   `unread_messages_count`.
4. A message sent by the authenticated user does not increment that user's
   unread message count.
5. One incoming pending message request increments only
   `message_requests_count`.
6. An outgoing message request does not increment the sender's request count.
7. Accepting, rejecting, cancelling, or expiring a request removes it from
   `message_requests_count`.
8. Reading or deleting a notification updates `notifications_count`.
9. Reading chat messages updates `unread_messages_count`.
10. Each aggregate value matches its corresponding existing list or count
    query.

## Temporary fallback

If an aggregate endpoint cannot be delivered immediately, the temporary
fallback is:

```http
GET message_requests_count
Authorization: Bearer <token>
```

```json
{
  "key": "success",
  "msg": "Message requests count retrieved successfully",
  "data": {
    "count": 2
  }
}
```

This fallback is compatible with the shapes of `count-notifications` and
`count-unread-messages`, but it is not the preferred final solution because it
requires three HTTP requests instead of one.
