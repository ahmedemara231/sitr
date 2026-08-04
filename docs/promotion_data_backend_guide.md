# Backend Guide: Separated Promotion Endpoints

## Objective

Replace the combined `GET promotion_data` response with four focused,
localized endpoints. The mobile app consumes them independently so each view
downloads only the data it needs.

| Endpoint | Mobile consumer | Returned content |
|---|---|---|
| `GET promotion_badge` | Home header for a non-promoted user | Promotion title, subtitle, and action |
| `GET promoted_badge` | Home header for a promoted user | Promoted title, subtitle, and status |
| `GET promotion_sheet` | Promotion reminder and promotion plans UI | Sheet copy and button templates |
| `GET promotion_plans?page={page}` | Paginated promotion plans UI | Paginated plans and the full features list |

The app chooses `promotion_badge` or `promoted_badge` from the authenticated
user's `is_promoted` profile state. It must not request both badge endpoints at
the same time.

The subscription endpoint is unchanged:

```http
POST profile_promotion_subscribtion
```

```json
{
  "plan_id": 2
}
```

The server must resolve the current price from `plan_id`. It must never trust
a price supplied by the mobile client.

## Shared request rules

All four endpoints require authentication and use the project's current
language headers.

```http
Accept: application/json
Accept-Language: ar
lang: ar
Authorization: Bearer <token>
```

- Supported languages are `ar` and `en`.
- Prefer `lang`, then `Accept-Language`, then the application default.
- Every displayed string in the response must already be localized.
- Use the standard `key`, `msg`, and `data` response wrapper.
- Return active/published records only.

## 1. Promotion badge

### Request

```http
GET promotion_badge
```

### Successful response

```json
{
  "key": "success",
  "msg": "Promotion badge loaded successfully",
  "data": {
    "title": "رقّي ملفك الآن",
    "subtitle": "احصل على مزايا حصرية",
    "action_text": "ابدأ الآن"
  }
}
```

### Required fields

| Field | Type | Validation |
|---|---|---|
| `title` | string | Required, plain text, maximum 60 characters |
| `subtitle` | string | Required, plain text, maximum 120 characters |
| `action_text` | string | Required, plain text, maximum 30 characters |

## 2. Promoted badge

### Request

```http
GET promoted_badge
```

### Successful response

```json
{
  "key": "success",
  "msg": "Promoted badge loaded successfully",
  "data": {
    "title": "ملفك مروّج",
    "subtitle": "ملفك مميز ويظهر أولاً",
    "status_text": "نشط"
  }
}
```

### Required fields

| Field | Type | Validation |
|---|---|---|
| `title` | string | Required, plain text, maximum 60 characters |
| `subtitle` | string | Required, plain text, maximum 120 characters |
| `status_text` | string | Required, plain text, maximum 30 characters |

Do not rename `status_text` to `action_text`. They have different meanings in
the dashboard and mobile UI.

## 3. Promotion sheet

### Request

```http
GET promotion_sheet
```

### Successful response

```json
{
  "key": "success",
  "msg": "Promotion sheet loaded successfully",
  "data": {
    "title": "الاشتراك المميز",
    "subtitle": "اختر الخطة التي تناسبك",
    "feature_intro": "المزايا التي ستحصل عليها",
    "subscribe_button_template": "اشترك في {duration} - {price} {currency}",
    "subscribed_success_text": "تم الاشتراك بنجاح",
    "cancel_anytime_text": "يمكنك الإلغاء في أي وقت"
  }
}
```

Plans and features must not be returned by this endpoint.

### Required fields

| Field | Type | Validation |
|---|---|---|
| `title` | string | Required, maximum 80 characters |
| `subtitle` | string | Required, maximum 200 characters |
| `feature_intro` | string | Required, maximum 80 characters |
| `subscribe_button_template` | string | Required, maximum 120 characters; placeholder rules below |
| `subscribed_success_text` | string | Required, maximum 80 characters |
| `cancel_anytime_text` | string | Required, maximum 120 characters |

The subscribe template supports only these exact placeholders:

| Placeholder | Mobile replacement |
|---|---|
| `{duration}` | Localized plan duration |
| `{price}` | Numeric plan price |
| `{currency}` | Localized currency label |

Do not translate or rename placeholders. Reject unknown or malformed
placeholders when an administrator publishes content.

## 4. Promotion plans and features

### Request

```http
GET promotion_plans?page=1
```

The backend may use its standard `per_page` query parameter if supported.
Sort plans by `sort_order` before applying pagination.

### Successful response

```json
{
  "key": "success",
  "msg": "Promotion plans loaded successfully",
  "data": {
    "plans": {
      "data": [
        {
          "id": 1,
          "code": "monthly",
          "duration": "شهر واحد",
          "price": 29,
          "currency": "ر.س",
          "period": "شهري",
          "description": "مزايا الترقية الأساسية",
          "badge": null,
          "is_highlighted": false,
          "is_default": false,
          "sort_order": 1
        },
        {
          "id": 2,
          "code": "quarterly",
          "duration": "3 أشهر",
          "price": 69,
          "currency": "ر.س",
          "period": "كل 3 أشهر",
          "description": "الأكثر طلباً",
          "badge": "الأكثر طلباً",
          "is_highlighted": true,
          "is_default": true,
          "sort_order": 2
        }
      ],
      "pagination": {
        "total_items": 2,
        "count_items": 2,
        "per_page": 10,
        "total_pages": 1,
        "current_page": 1,
        "next_page_url": null,
        "prev_page_url": null
      }
    },
    "features": [
      {
        "id": 1,
        "code": "search_priority",
        "title": "يظهر الملف أولاً في نتائج البحث",
        "sort_order": 1
      }
    ]
  }
}
```

This nesting is required:

- `data.plans.data` is the paginated list consumed by `AppPagify`.
- `data.plans.pagination` has the same pagination object style used by the
  notifications response.
- `data.features` is the complete active feature list, not paginated.
- Return `data.features` on every page so a direct request to any valid page
  remains a complete response.

### Pagination rules

| Field | Type | Rules |
|---|---|---|
| `total_items` | integer | Total active plans across all pages |
| `count_items` | integer | Number of plans in the current page |
| `per_page` | integer | Page size |
| `total_pages` | integer | Total number of pages; at least `1` when plans exist |
| `current_page` | integer | Requested page |
| `next_page_url` | string or null | URL for the next page |
| `prev_page_url` | string or null | URL for the previous page |

The mobile parser temporarily also accepts the legacy typo
`perv_page_url`, but new backend code must return `prev_page_url`.

### Plan fields

| Field | Type | Rules |
|---|---|---|
| `id` | integer | Required, stable primary key, accepted by the subscription endpoint |
| `code` | string | Required, stable, unique, language-independent |
| `duration` | string | Required, localized |
| `price` | number | Required, non-negative, never a formatted string |
| `currency` | string | Required, localized label |
| `period` | string | Required, localized billing period |
| `description` | string | Required, localized |
| `badge` | string or null | Localized; return `null` when absent |
| `is_highlighted` | boolean | Controls emphasized styling |
| `is_default` | boolean | Marks the initially selected plan |
| `sort_order` | integer | Required and used before pagination |

Exactly one active plan must have `is_default: true`. The default plan should
be ordered onto the first page so the initial mobile selection is stable.

Do not hard-delete plans referenced by subscriptions or payments. Mark them
inactive so history remains valid while the plan disappears from this
endpoint.

### Feature fields

| Field | Type | Rules |
|---|---|---|
| `id` | integer | Required, stable primary key |
| `code` | string | Required, stable, unique, language-independent |
| `title` | string | Required, localized |
| `sort_order` | integer | Required; return features in this order |

## Dashboard requirements

Create a Promotion Content area with Arabic and English tabs. Administrators
must edit forms, not raw JSON.

Provide four sections:

1. Promotion badge: title, subtitle, action text.
2. Promoted badge: title, subtitle, status text.
3. Promotion sheet: all six localized text fields and a template preview.
4. Plans and features: create/edit, activate/deactivate, default selection,
   highlighting, and drag-to-reorder.

Publishing rules:

- Require complete Arabic and English content.
- Treat content as plain text; trim it and reject HTML/script input.
- Validate plan/default/order rules server-side.
- Clear the previous default plan in the same transaction when a new default
  is selected.
- Keep an audit trail with the administrator, timestamp, and changed values.
- If API responses are cached, cache by endpoint and language, then invalidate
  all affected `ar` and `en` entries immediately after publishing.

## Suggested storage

Use normalized tables following the backend's naming conventions:

```text
promotion_badge_content
  title_ar, title_en
  subtitle_ar, subtitle_en
  action_text_ar, action_text_en

promoted_badge_content
  title_ar, title_en
  subtitle_ar, subtitle_en
  status_text_ar, status_text_en

promotion_sheet_content
  title_ar, title_en
  subtitle_ar, subtitle_en
  feature_intro_ar, feature_intro_en
  subscribe_button_template_ar, subscribe_button_template_en
  subscribed_success_text_ar, subscribed_success_text_en
  cancel_anytime_text_ar, cancel_anytime_text_en

promotion_plans
  id, code, price
  duration_ar, duration_en
  currency_ar, currency_en
  period_ar, period_en
  description_ar, description_en
  badge_ar nullable, badge_en nullable
  is_highlighted, is_default, is_active, sort_order

promotion_features
  id, code
  title_ar, title_en
  is_active, sort_order
```

Seed both languages with the current production copy before switching the
mobile app away from `promotion_data`.

## Error responses

Use the existing project error wrapper and an appropriate non-2xx status:

```json
{
  "key": "fail",
  "msg": "Promotion content is not configured",
  "data": null
}
```

Do not return a successful partial configuration. Validate a draft before it
becomes the published version.

## Acceptance checklist

- `promotion_data` is no longer needed by the updated mobile app.
- All four endpoint names and JSON structures exactly match this guide.
- Arabic and English requests return localized content.
- The home header requests only the badge matching `is_promoted`.
- `promotion_sheet` does not include plans or features.
- `promotion_plans` returns paginated plans plus the full features list.
- Pagination values are correct for first, middle, last, empty, and invalid
  page requests.
- Exactly one active plan is default and it is included on the first page.
- Every returned plan ID is accepted by `profile_promotion_subscribtion`.
- Subscription prices are resolved and validated server-side.
- Publishing invalidates every endpoint/language cache affected by the change.
