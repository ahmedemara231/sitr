# Backend Handoff: Fix `Undefined array key "receiver"`

## Problem

`POST send_message_request` currently fails with:

```text
Undefined array key "receiver"
```

The Flutter app does not send a field named `receiver`. It sends the receiver's
ID using the existing API key `receiver_id`:

```http
POST /send_message_request
Authorization: Bearer <sender-token>
Content-Type: application/json

{
  "receiver_id": "42"
}
```

The mobile request is created by
`RequestModel.toMessageRequestJson()` and contains only `receiver_id`.

## Likely cause

Some part of the endpoint is reading an array entry that was never provided,
for example:

```php
$receiver = $validated['receiver'];
```

or:

```php
$receiver = $request->all()['receiver'];
```

The request key and backend lookup do not match:

| Mobile request key | Backend is likely reading |
|---|---|
| `receiver_id` | `receiver` |

Check the exception stack trace for the first application file and search the
entire `send_message_request` flow for `['receiver']`. The invalid lookup may
be in the controller, FormRequest, action/service, repository, notification,
event, or queued job.

## Required fix

Use `receiver_id` as the canonical request key. Validate it before reading it,
then resolve the receiver model explicitly.

Example Laravel FormRequest:

```php
public function rules(): array
{
    return [
        'receiver_id' => [
            'required',
            'integer',
            'exists:users,id',
            Rule::notIn([$this->user()->id]),
        ],
    ];
}
```

Example controller/action:

```php
public function __invoke(SendMessageRequest $request): JsonResponse
{
    $validated = $request->validated();

    $sender = $request->user();
    $receiverId = (int) $validated['receiver_id'];
    $receiver = User::query()->findOrFail($receiverId);

    $messageRequest = DB::transaction(function () use ($sender, $receiver) {
        return MessageRequest::query()->create([
            'sender_id' => $sender->id,
            'receiver_id' => $receiver->id,
            'status' => MessageRequestStatus::PENDING,
        ]);
    });

    // Dispatch notifications/events after the transaction commits.

    return response()->json([
        'key' => 'success',
        'msg' => 'Message request sent',
        'data' => [
            'can_chat' => false,
            'reason' => 'chat_request_sent',
        ],
    ]);
}
```

Adapt model and enum names to the backend codebase. The important correction is
to read `$validated['receiver_id']`, not `$validated['receiver']`.

If an internal service currently requires a receiver model, pass the resolved
`$receiver` variable to it. Do not expect a `receiver` object inside the HTTP
request payload.

## Validation and security requirements

- Derive the sender from the authenticated bearer token.
- Never accept `sender_id` from the request body as proof of identity.
- Require `receiver_id`.
- Reject a receiver that does not exist, is inactive/deleted, or is the
  authenticated sender.
- Re-run all chat eligibility rules inside this endpoint.
- Prevent duplicate pending requests for the same
  `sender_id`/`receiver_id` pair.
- Use a transaction or database constraint to prevent race-condition
  duplicates.
- Return a normal `422` validation response for missing/invalid input instead
  of allowing a PHP warning to become a `500` response.

Recommended missing-field response:

```http
HTTP/1.1 422 Unprocessable Entity
Content-Type: application/json
```

```json
{
  "key": "error",
  "message": "The receiver id field is required.",
  "errors": {
    "receiver_id": [
      "The receiver id field is required."
    ]
  }
}
```

## Acceptance tests

1. A valid authenticated request with `receiver_id` creates one pending
   message request and returns `200`/`201`.
2. The created row uses the authenticated user's ID as `sender_id`.
3. Omitting `receiver_id` returns `422`, with no PHP warning or `500`.
4. An unknown, inactive, deleted, or self receiver is rejected.
5. Repeating the same pending request does not create a duplicate.
6. No controller, service, notification, event, or job reads an undefined
   `receiver` array key.
7. The successful response contains:

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

## Mobile-side evidence

The current Flutter implementation sends:

```dart
Map<String, dynamic> toMessageRequestJson() => {
  'receiver_id': receiverId,
};
```

The app sends that map as the JSON body of `POST send_message_request`; it does
not rename the key or convert the request to multipart form data.
