# Delete Account Safety API

The mobile app needs a preflight endpoint that determines whether the authenticated user's account can currently be deleted. This request is made immediately before the existing `POST /api/v1/delete-account` request.

## Endpoint

```http
GET /api/v1/delete_safety
Authorization: Bearer <token>
Accept: application/json
```

Authentication is required. The endpoint must not delete or mutate the user account.

## Safe response

When the user has no active package and no active/live chat:

```json
{
  "key": "success",
  "msg": "Account can be deleted",
  "data": {
    "is_safe": {
      "value": true,
      "reason": null
    }
  }
}
```

## Unsafe responses

When the user has an active package:

```json
{
  "key": "success",
  "msg": "Account cannot be deleted",
  "data": {
    "is_safe": {
      "value": false,
      "reason": "has_active_package"
    }
  }
}
```

When the user has an active/live chat:

```json
{
  "key": "success",
  "msg": "Account cannot be deleted",
  "data": {
    "is_safe": {
      "value": false,
      "reason": "has_live_chat"
    }
  }
}
```

## Contract

| Field | Type | Required | Allowed values |
|---|---|---|---|
| `data.is_safe.value` | boolean | Yes | `true`, `false` |
| `data.is_safe.reason` | string/null | Yes | `null` when safe; `has_active_package` or `has_live_chat` when unsafe |

When `value` is `false`, `reason` must contain exactly one of these two values:

- `has_active_package`: the user has an active package.
- `has_live_chat`: the user has an active/live chat.

The API must return a JSON boolean for `value`, not `1`, `0`, or a string. Do not return any other reason value. When both unsafe conditions apply, return one of the two allowed reasons according to backend business priority.

## Mobile behavior

1. The app calls `GET /api/v1/delete_safety` after the user selects a deletion reason and taps Continue.
2. If `data.is_safe.value` is `false`, the app displays a localized message based on `data.is_safe.reason` and does not call the deletion endpoint.
3. If `data.is_safe.value` is `true`, the app calls the existing `POST /api/v1/delete-account` endpoint with the selected deletion reason.
4. Standard non-success HTTP/API errors are displayed through the existing app error flow; deletion is not attempted.
