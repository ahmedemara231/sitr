# Delete Account Reasons — API Updates

> **Summary:** Delete-account now requires a reason (`reason_id` **or** custom `reason` text). A new endpoint lists predefined reasons. Reasons are managed from the admin dashboard.

---

## 1. List Delete Account Reasons (New)

**Endpoint:** `GET /api/v1/delete-account-reasons`

**Auth:** Optional (same group as `relations`)

**Response:**
```json
{
  "key": "success",
  "msg": "Delete Account Reasons",
  "data": [
    {
      "id": 1,
      "text": "I no longer need the app"
    },
    {
      "id": 2,
      "text": "Privacy concerns"
    }
  ]
}
```

| Field  | Type   | Description                          |
|--------|--------|--------------------------------------|
| `id`   | int    | Reason ID — send as `reason_id`      |
| `text` | string | Localized reason text (ar/en by lang)|

**Mobile flow:** Call this before showing the delete-account screen, then let the user pick a reason or enter custom text.

---

## 2. Delete Account (Updated Request)

**Endpoint:** `POST /api/v1/delete-account`

**Auth:** Required (`Bearer` token) + `is-active`

### Request body

Send **exactly one** of `reason_id` or `reason` (required). `device_id` stays optional.

#### Option A — predefined reason
```json
{
  "reason_id": 1,
  "device_id": "optional-device-id"
}
```

#### Option B — custom reason text
```json
{
  "reason": "Other reason written by the user",
  "device_id": "optional-device-id"
}
```

### Request fields

| Field       | Type   | Required                         | Rules                                      |
|-------------|--------|----------------------------------|--------------------------------------------|
| `reason_id` | int    | Required **without** `reason`    | Must exist in `delete_account_reasons`     |
| `reason`    | string | Required **without** `reason_id` | Max 500 characters                         |
| `device_id` | string | Optional                         | Deletes matching device record on logout   |

### Validation (`DeleteAccountRequest`)

```php
'reason_id' => 'nullable|integer|exists:delete_account_reasons,id,deleted_at,NULL|required_without:reason',
'reason'    => 'nullable|string|max:500|required_without:reason_id',
'device_id' => 'nullable|string',
```

### Success response
```json
{
  "key": "success",
  "msg": "Account deleted successfully"
}
```

### Error cases (unchanged business rules)

| Case                         | Message key                                      |
|------------------------------|--------------------------------------------------|
| Wallet balance > 0           | `auth.cannot_delete_account_with_balance`        |
| Active match / open chat     | `auth.cannot_delete_account_with_active_chats`   |
| Missing both reason fields   | Validation fail (first error message)            |
| Invalid `reason_id`          | Validation fail (exists rule)                    |

---

## 3. What Gets Stored

Before soft-deleting the user, the API writes:

| Column                       | When `reason_id` is sent                         | When `reason` is sent      |
|------------------------------|--------------------------------------------------|----------------------------|
| `delete_account_reason_id`   | The selected reason ID                           | `null`                     |
| `delete_account_reason`      | Snapshot of the reason text at delete time       | Custom text as sent        |

---

## 4. Admin Dashboard

CRUD for predefined reasons:

- URL: `/admin/deleteaccountreasons`
- Translatable name (ar / en)
- Soft delete; cannot delete a reason already used by users

---

## 5. Quick Mobile Checklist

1. `GET /api/v1/delete-account-reasons` → show list of `{ id, text }`
2. User selects an item **or** types a custom reason
3. `POST /api/v1/delete-account` with either:
   - `{ "reason_id": <id> }`  
   - or `{ "reason": "<custom text>" }`
4. On success → clear local session / navigate to login
