# Backend and Dashboard Guide: Promotion Data

## Objective

Create one localized endpoint named `promotion_data` that supplies all
dashboard-managed content used by:

- the promotion badge shown to a user who is not promoted;
- the promoted badge shown to a promoted user;
- the promotion plans sheet, including its heading, plans, features, button
  text, success text, and cancellation note.

The mobile app now reads the plans from this endpoint instead of
`profile-promotion-plans`. The existing subscription endpoint remains
unchanged:

```text
POST profile_promotion_subscribtion
```

The subscription request continues to use the stable plan ID returned by
`promotion_data`:

```json
{
  "plan_id": 2
}
```

This endpoint owns content and plan configuration only. Badge/sheet icons,
colors, typography, spacing, and layout remain native mobile-app concerns and
must not be added as dashboard fields.

## Mobile API contract

### Request

```http
GET promotion_data
Accept: application/json
Accept-Language: ar
lang: ar
Authorization: Bearer <token>
```

Supported languages are `ar` and `en`. Prefer the `lang` header, then
`Accept-Language`, and use the application's default language only when both
are absent or unsupported.

### Successful response

Return HTTP `200` with the project's standard `key`, `msg`, and `data`
wrapper. Every displayed string must already be translated into the requested
language.

```json
{
  "key": "success",
  "msg": "Promotion data loaded successfully",
  "data": {
    "promotion_badge": {
      "title": "Upgrade your profile",
      "subtitle": "Get exclusive benefits",
      "action_text": "Start now"
    },
    "promoted_badge": {
      "title": "Your profile is promoted",
      "subtitle": "Your profile is highlighted and appears first",
      "status_text": "Active"
    },
    "promotion_sheet": {
      "title": "Premium subscription",
      "subtitle": "Choose the package that suits you",
      "feature_intro": "What you will get",
      "subscribe_button_template": "Subscribe to {duration} - {price} {currency}",
      "subscribed_success_text": "Subscribed successfully",
      "cancel_anytime_text": "You can cancel anytime",
      "plans": [
        {
          "id": 1,
          "code": "monthly",
          "duration": "One month",
          "price": 100,
          "currency": "SAR",
          "period": "monthly",
          "description": "Try the promotion benefits for one month",
          "badge": null,
          "is_highlighted": false,
          "is_default": false,
          "sort_order": 1
        },
        {
          "id": 2,
          "code": "quarterly",
          "duration": "3 months",
          "price": 240,
          "currency": "SAR",
          "period": "every 3 months",
          "description": "Save compared with the monthly plan",
          "badge": "Most requested",
          "is_highlighted": true,
          "is_default": true,
          "sort_order": 2
        }
      ],
      "features": [
        {
          "id": 1,
          "code": "search_priority",
          "title": "Your profile appears first in search results",
          "sort_order": 1
        },
        {
          "id": 2,
          "code": "golden_verification",
          "title": "Golden verification badge",
          "sort_order": 2
        }
      ]
    }
  }
}
```

### Field rules

| JSON path | Type | Rules |
|---|---|---|
| `promotion_badge.title` | string | Required, plain text, maximum 60 characters |
| `promotion_badge.subtitle` | string | Required, plain text, maximum 120 characters |
| `promotion_badge.action_text` | string | Required, maximum 30 characters |
| `promoted_badge.title` | string | Required, plain text, maximum 60 characters |
| `promoted_badge.subtitle` | string | Required, plain text, maximum 120 characters |
| `promoted_badge.status_text` | string | Required, maximum 30 characters |
| `promotion_sheet.title` | string | Required, maximum 80 characters |
| `promotion_sheet.subtitle` | string | Required, maximum 200 characters |
| `promotion_sheet.feature_intro` | string | Required, maximum 80 characters |
| `promotion_sheet.subscribe_button_template` | string | Required; supports only the placeholders listed below |
| `promotion_sheet.subscribed_success_text` | string | Required, maximum 80 characters |
| `promotion_sheet.cancel_anytime_text` | string | Required, maximum 120 characters |
| `plans` | array | Return active plans only, sorted by `sort_order` |
| `features` | array | Return active features only, sorted by `sort_order` |

The subscribe-button template supports these exact placeholders:

| Placeholder | Replaced with |
|---|---|
| `{duration}` | The localized plan duration |
| `{price}` | The plan price |
| `{currency}` | The localized currency label |

Do not translate or rename the placeholders. The dashboard should show a
preview and reject unknown or malformed placeholders. A valid Arabic example
is:

```text
اشترك في باقة {duration} - {price} {currency}
```

### Plan rules

- `id` must be a stable integer primary key and must be the same ID accepted by
  `profile_promotion_subscribtion`.
- `code` must be stable, unique, and language-independent.
- `price` must be a JSON number, not a formatted string.
- `duration`, `currency`, `period`, `description`, and `badge` are localized.
- `badge` may be `null`; do not return an empty string when no badge is set.
- Exactly one active plan should have `is_default: true`.
- `is_highlighted` controls the emphasized visual treatment but does not
  automatically make a plan the default.
- `sort_order` must be an integer and should be unique among active plans.
- Never trust a price sent by the client. The subscription endpoint must load
  the current plan and price by `plan_id` on the server.
- Do not hard-delete a plan referenced by subscriptions or payments. Mark it
  inactive so it disappears from `promotion_data` while history remains valid.

### Feature rules

- `id` is a stable integer primary key.
- `code` is stable, unique, and language-independent.
- `title` is localized.
- `sort_order` controls display order.
- Return active features only.

## Dashboard requirements

Add a **Promotion content** page with Arabic and English tabs. Do not make
administrators edit raw JSON.

### Badge sections

Provide separate forms for:

1. Promotion badge
   - title;
   - subtitle;
   - action text.
2. Promoted badge
   - title;
   - subtitle;
   - status text.

Show a compact preview for each badge and enforce the field lengths in the
contract.

### Promotion sheet section

Provide editable Arabic and English fields for:

- title;
- subtitle;
- feature intro;
- subscribe-button template;
- subscribed-success text;
- cancel-anytime text.

Show a button preview using a real active plan so administrators can verify
placeholder replacement and text length.

### Plans manager

Provide create/edit, activate/deactivate, and drag-to-reorder controls for
plans. The dashboard must allow editing:

- stable code;
- Arabic and English duration;
- numeric price;
- Arabic and English currency;
- Arabic and English billing period;
- Arabic and English description;
- optional Arabic and English badge;
- highlighted flag;
- default flag;
- active flag;
- sort order.

When a new default is selected, clear the previous default in the same
transaction. Prevent publishing when there is no active default plan or when
two active plans are marked as default.

### Features manager

Provide create/edit, activate/deactivate, and drag-to-reorder controls for
features. Each feature needs:

- stable code;
- Arabic title;
- English title;
- active flag;
- sort order.

## Suggested storage

The exact schema may follow the backend's conventions, but the data should be
normalized rather than stored as one unvalidated JSON blob.

Suggested tables:

```text
promotion_content
  id
  promotion_title_ar
  promotion_title_en
  promotion_subtitle_ar
  promotion_subtitle_en
  promotion_action_ar
  promotion_action_en
  promoted_title_ar
  promoted_title_en
  promoted_subtitle_ar
  promoted_subtitle_en
  promoted_status_ar
  promoted_status_en
  sheet_title_ar
  sheet_title_en
  sheet_subtitle_ar
  sheet_subtitle_en
  feature_intro_ar
  feature_intro_en
  subscribe_template_ar
  subscribe_template_en
  subscribed_success_ar
  subscribed_success_en
  cancel_anytime_ar
  cancel_anytime_en
  updated_by
  updated_at

promotion_plans
  id
  code
  duration_ar
  duration_en
  price
  currency_ar
  currency_en
  period_ar
  period_en
  description_ar
  description_en
  badge_ar nullable
  badge_en nullable
  is_highlighted
  is_default
  is_active
  sort_order
  timestamps

promotion_features
  id
  code
  title_ar
  title_en
  is_active
  sort_order
  timestamps
```

Seed both languages with the current production mobile copy before releasing
the endpoint so an empty dashboard never produces an unusable response.

## Publishing, validation, and caching

- Treat all content as plain text. Strip HTML/script content and trim leading
  and trailing whitespace.
- Require both Arabic and English values before publishing.
- Validate all plan and feature rules server-side even if the dashboard also
  validates them.
- Save related default-plan and ordering changes transactionally.
- Keep an audit trail containing the administrator, timestamp, and changed
  values.
- If the API response is cached on the backend, key the cache by language and
  invalidate both `ar` and `en` entries immediately after a dashboard publish.
- The mobile app keeps a per-language last-known-good response for offline
  fallback. It requests fresh data whenever the relevant screen is opened.

## Error responses

Use the existing project error wrapper. Examples:

```json
{
  "key": "fail",
  "msg": "Promotion data is not configured",
  "data": null
}
```

Do not return HTTP `200` with `key: "success"` and a partial or invalid
configuration. Validate the published configuration before it becomes active.

## Acceptance checklist

- `GET promotion_data` returns the exact standard wrapper and object structure.
- `lang: ar` returns Arabic content and `lang: en` returns English content.
- Both badge variants change after a dashboard publish.
- Sheet headings, button template, success text, and cancellation note change
  after a dashboard publish.
- Active plans and features can be added, edited, hidden, and reordered.
- Only one active plan is returned as the default.
- Returned plan IDs work with `POST profile_promotion_subscribtion`.
- Subscription pricing is resolved server-side from the selected plan ID.
- Dashboard publishing invalidates language-specific backend caches.
- Empty, partial, unsafe, or structurally invalid content cannot be published.
