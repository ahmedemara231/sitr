# Profile Promotion and Payment Backend Guide

This document is the backend contract for the Satr profile-promotion cycle for
both individual and parent accounts. It also documents the payment-return rule
that must be applied to the existing online `subscribe-package` flow.

The backend must treat payment verification and promotion activation as
server-side responsibilities. The mobile app only opens the checkout URL,
detects the final browser route, and refreshes the authenticated profile.

## 1. Required backend changes

The backend must provide all of the following:

1. A persistent promotion-plan configuration.
2. `GET profile-promotion-plans`.
3. `POST profile_promotion_subscribtion`.
4. Payment-gateway integration for profile promotion, reusing the same trusted
   gateway service used by `POST subscribe-package`.
5. A real JSON boolean named `is_promoted` in individual and parent responses.
6. Promotion activation only after the server verifies a successful payment.
7. Final HTTPS payment routes containing lowercase `success` or `failed`.
8. The same final-route rule for online `subscribe-package` payments on both
   Android and iOS.

> Important: `profile_promotion_subscribtion` contains the existing
> `subscribtion` spelling. The current mobile app calls this exact route.
> Renaming it requires a coordinated mobile release. The backend may add a
> correctly spelled alias, but it must keep the current route working.

## 2. Standard API envelope

All endpoints must use the application's standard response envelope:

```json
{
  "key": "success",
  "msg": "Human-readable message",
  "data": {}
}
```

Validation and business errors should use the project's normal non-2xx error
format. Do not return a successful HTTP/API response with an empty checkout
link.

Authenticated endpoints require the existing bearer token. The backend must
derive the user from that token; it must not accept a client-supplied `user_id`
for promotion purchases.

## 3. The `is_promoted` key

### 3.1 Type and meaning

Every relevant user or opportunity object must contain:

```json
{
  "is_promoted": true
}
```

Requirements:

- The value must be a JSON boolean: `true` or `false`.
- Do not send `1`, `0`, `"true"`, `"false"`, or `null`.
- `true` means the user's promotion entitlement is currently active.
- `false` means no active entitlement exists, the payment failed, the
  entitlement expired, or it was revoked/refunded.
- The client must never be allowed to set this field through profile-update
  endpoints.

The mobile UI uses this value as follows:

- `true`: show the premium badge for individual and parent users.
- `false`: hide the premium badge.
- On the authenticated individual profile, `false` also shows the promotion
  purchase call-to-action.

### 3.2 Responses that must include it

The backend must include `is_promoted` consistently in:

- `GET profile` for individual accounts.
- `GET profile` for parent accounts.
- `GET opportunity-profile/{id}`.
- `GET get-child-profile/{id}` when the returned object is shown as a profile.
- `GET home` inside `opportunities.male`, `opportunities.female`, and
  `opportunities.parent`.
- `GET opportunities?type=male|female|parent&page={page}` for every item.
- `GET filter` for every returned opportunity.
- Any other response that returns the same individual or parent summary model.

Example authenticated individual or parent profile:

```json
{
  "key": "success",
  "msg": "Profile loaded",
  "data": {
    "id": 42,
    "name": "User name",
    "type": {
      "title": "Parent",
      "value": "parent"
    },
    "is_promoted": true
  }
}
```

Example paginated parent opportunities:

```json
{
  "key": "success",
  "msg": "Opportunities loaded",
  "data": {
    "parent": {
      "data": [
        {
          "id": 42,
          "name": "User name",
          "is_promoted": true
        }
      ],
      "pagination": {
        "per_page": 10,
        "total_pages": 3
      }
    }
  }
}
```

The same item-level key is required for the `male` and `female` lists.

### 3.3 Recommended server-side calculation

`is_promoted` should be derived from authoritative entitlement data, for
example:

```text
payment status = paid
AND promotion status = active
AND starts_at <= now
AND (expires_at is null OR expires_at > now)
AND refunded_at is null
```

The backend may store a denormalized `users.is_promoted` value for fast reads,
but it must keep it synchronized with the authoritative promotion entitlement.
A scheduled job should expire promotions and set the returned value to `false`.

Promoted users should be sorted before non-promoted users wherever the plan
benefit promises search priority. Keep the existing secondary sorting and
pagination deterministic, for example:

```text
ORDER BY is_promoted DESC, existing_rank DESC, id DESC
```

## 4. Promotion plans endpoint

### Request

```http
GET profile-promotion-plans
Authorization: Bearer <token>
```

### Required response

```json
{
  "key": "success",
  "msg": "Promotion plans loaded successfully",
  "data": {
    "plans": [
      {
        "id": 1,
        "code": "monthly",
        "duration": "One month",
        "price": 29,
        "currency": "SAR",
        "period": "monthly",
        "description": "Basic promotion benefits",
        "badge": null,
        "is_highlighted": false,
        "is_default": false,
        "sort_order": 1
      },
      {
        "id": 2,
        "code": "quarterly",
        "duration": "3 months",
        "price": 69,
        "currency": "SAR",
        "period": "every 3 months",
        "description": "Most popular",
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
        "title": "Profile appears first in search results",
        "sort_order": 1
      }
    ]
  }
}
```

### Plan keys

| Key | Type | Required | Backend meaning |
|---|---:|---:|---|
| `id` | integer | Yes | Stable plan ID sent during subscription |
| `code` | string | Recommended | Stable internal code |
| `duration` | string | Yes | Localized visible duration/title |
| `price` | number | Yes | Server-authoritative checkout price |
| `currency` | string | Yes | Visible currency |
| `period` | string | Yes | Visible billing period |
| `description` | string | Yes | Visible plan description |
| `badge` | string/null | No | Optional plan label |
| `is_highlighted` | boolean | Yes | Highlighted card styling |
| `is_default` | boolean | Yes | Initially selected plan |
| `sort_order` | integer | Yes | Display order |

At least one active plan must be returned. Prefer exactly one default plan.

The app can also read the following aliases, although the canonical keys above
should be used:

- Plans list: `promotion_plans` or `packages`.
- Features list: `promotion_features` or `benefits`.
- Plan ID: `plan_id` or `package_id`.
- Duration: `title` or `name`.
- Price: `amount`.
- Period: `per` or `billing_period`.
- Description: `desc` or `subtitle`.
- Badge: `label` or `tag`.
- Highlight: `highlight` or `is_popular`.
- Default: `default` or `selected_by_default`.
- Sort order: `order`.

## 5. Promotion subscription endpoint

### Request

```http
POST profile_promotion_subscribtion
Authorization: Bearer <token>
Content-Type: application/json
```

```json
{
  "plan_id": 2
}
```

The current promotion client sends only `plan_id`. It does not send
`brand_id`, `payment_method`, price, currency, or user ID.

The backend must:

1. Resolve the authenticated user from the bearer token.
2. Validate that the plan exists, is active, and is purchasable.
3. Read price, currency, and duration from the server database.
4. Create a unique pending promotion-payment transaction.
5. Reuse the same payment-gateway service/infrastructure used by
   `subscribe-package`.
6. Use the configured default online payment brand if the gateway service
   normally requires a brand.
7. Attach server-side metadata such as transaction ID, user ID, plan ID, and
   payment purpose `profile_promotion`.
8. Configure the success and failed return URLs described in section 7.
9. Return the gateway checkout URL.

### Required response

```json
{
  "key": "success",
  "msg": "Payment link generated successfully",
  "data": {
    "link": "https://payment-gateway.example/checkout/session-id"
  }
}
```

Canonical response key: `data.link`.

The app can also read `data.redirect_url` or `data.url`, but `link` is
preferred for this endpoint.

Never trust a price or duration from the client. Never mark the user as
promoted merely because the client opened the checkout page.

## 6. Server-side payment lifecycle

The promotion payment should follow this sequence:

```text
Mobile app
  -> POST profile_promotion_subscribtion
Backend
  -> create pending transaction
  -> create payment-gateway checkout session
  -> return data.link
Mobile WebView
  -> opens gateway checkout
Payment gateway
  -> sends signed webhook/callback to backend
Backend
  -> verifies signature and payment with provider
  -> atomically marks transaction paid
  -> activates or extends promotion entitlement
  -> makes GET profile return is_promoted=true
Gateway/browser
  -> loads final HTTPS route containing lowercase "success"
Mobile app
  -> closes WebView
  -> calls GET profile
  -> stores refreshed user and shows payment success
```

For a failed, cancelled, or expired payment:

```text
Backend
  -> keeps transaction non-paid
  -> does not activate promotion
  -> keeps is_promoted unchanged
Gateway/browser
  -> loads final HTTPS route containing lowercase "failed"
Mobile app
  -> closes WebView without showing payment success
```

### Critical timing rule

The mobile app refreshes `GET profile` immediately after detecting the success
URL. Therefore, the backend must commit the paid transaction and promotion
entitlement before it sends or renders the final success route.

If the payment provider redirects the browser before its webhook arrives, the
backend success-return handler must verify the payment directly with the
provider or wait until the verified transaction is committed. It must not
return a success route while `GET profile` can still return
`"is_promoted": false`.

### Idempotency

Webhook and return handlers may be called multiple times. The backend must:

- Store the provider transaction/reference ID with a unique constraint.
- Make payment confirmation idempotent.
- Activate or extend the entitlement only once per paid transaction.
- Never charge or extend twice because of repeated callbacks.
- Record failed, cancelled, expired, and refunded states.

### Security

- Verify the gateway signature.
- Verify amount, currency, merchant account, transaction ID, and payment
  status server-side.
- Do not trust success/failure query parameters without gateway verification.
- Do not activate from a mobile request or browser redirect alone.
- Use HTTPS for checkout, webhook, and final return routes.
- Use an opaque signed payment/session reference in browser return URLs.
- Do not place sensitive user data in return URLs.

## 7. Mandatory final-route keywords for Android and iOS

The same Flutter WebView is used on Android and iOS. It performs a
case-sensitive check whenever a page starts loading.

### Successful payment

The final URL loaded inside the WebView must contain the exact lowercase
keyword:

```text
success
```

Recommended examples:

```text
https://api.example.com/payments/profile-promotion/success?transaction=abc123
https://api.example.com/payments/package/success?transaction=xyz789
```

### Failed, cancelled, or abandoned payment

The final URL loaded inside the WebView must contain the exact lowercase
keyword:

```text
failed
```

Recommended examples:

```text
https://api.example.com/payments/profile-promotion/failed?transaction=abc123
https://api.example.com/payments/package/failed?transaction=xyz789
```

### Non-negotiable route rules

- Use lowercase `success` and `failed`.
- Put the keyword in the HTTPS path, not only in page text.
- Use the same rule for Android and iOS.
- The route must load inside the current WebView.
- Do not return only a native deep link or open an external browser.
- A success URL must not also contain `fail`, `failed`, or `failure`.
- A failed URL must not contain `success` anywhere in its host, path, query, or
  fragment.
- Gateway webhooks do not need these keywords because they are server-to-server;
  the browser return/final route does.

The current app additionally recognizes `fail` and `failure`, but the backend
contract should use the single canonical failure keyword `failed`.

## 8. Apply the same route rule to `subscribe-package`

The existing online package endpoint is:

```http
POST subscribe-package
Authorization: Bearer <token>
Content-Type: application/json
```

Example online request:

```json
{
  "brand_id": 3,
  "package_id": 12,
  "payment_method": "online"
}
```

Expected online response:

```json
{
  "key": "success",
  "msg": "Payment link generated successfully",
  "data": {
    "redirect_url": "https://payment-gateway.example/checkout/session-id"
  }
}
```

For `payment_method: "online"`:

1. Reuse the verified server-side payment lifecycle in section 6.
2. Activate the package before serving the browser success route.
3. Return a final lowercase `/success` route after verified payment.
4. Return a final lowercase `/failed` route for failure, cancellation, expiry,
   or user cancellation.
5. Apply the same routes and behavior on Android and iOS.

Canonical examples:

```text
https://api.example.com/payments/package/success?transaction=xyz789
https://api.example.com/payments/package/failed?transaction=xyz789
```

For `payment_method: "wallet"`, no WebView redirect is used. The backend must
atomically validate the balance, debit the wallet, activate the package, and
return the standard successful API envelope.

`renew-package` uses the same mobile WebView for online payment and should use
the same final-route convention:

```json
{
  "brand_id": 3,
  "user_package_id": 99,
  "package_id": 12,
  "payment_method": "online"
}
```

## 9. Suggested database records

Table names may follow the backend's conventions, but the backend needs the
equivalent of the following data.

### Promotion plan

```text
id
code
duration/value used to calculate expires_at
price
currency
localized title/duration/period/description
badge
is_highlighted
is_default
sort_order
is_active
created_at
updated_at
```

### Promotion payment transaction

```text
id
user_id
promotion_plan_id
provider
provider_transaction_id (unique)
provider_checkout_id
amount
currency
status: pending | paid | failed | cancelled | expired | refunded
checkout_url
paid_at
failed_at
refunded_at
raw_verified_callback or audit reference
created_at
updated_at
```

### User promotion entitlement

```text
id
user_id
promotion_plan_id
payment_transaction_id (unique)
status: active | expired | revoked | refunded
starts_at
expires_at
created_at
updated_at
```

Individual and parent accounts must use the same promotion-entitlement rules.
Do not implement promotion only for one account type.

## 10. Expiry, refund, and renewal behavior

- On successful first purchase, create an active entitlement.
- On renewal while active, define one server policy and apply it consistently:
  normally extend from the current `expires_at`.
- On renewal after expiry, start from the verified payment time.
- On expiry, return `is_promoted: false`.
- On a verified refund or chargeback, revoke the related entitlement and return
  `is_promoted: false` unless another paid entitlement remains active.
- A failed payment must never remove an already active promotion.

## 11. Acceptance checklist

### API and model checks

- [ ] `GET profile-promotion-plans` returns at least one valid plan.
- [ ] `POST profile_promotion_subscribtion` accepts `plan_id`.
- [ ] Promotion checkout response contains a non-empty `data.link`.
- [ ] Individual `GET profile` returns boolean `is_promoted`.
- [ ] Parent `GET profile` returns boolean `is_promoted`.
- [ ] Male, female, and parent opportunity items return boolean
      `is_promoted`.
- [ ] Filter results return boolean `is_promoted`.
- [ ] Expired/refunded promotions return `is_promoted: false`.

### Payment checks

- [ ] Promotion amount and duration come from the server plan.
- [ ] Gateway callback signature and transaction are verified.
- [ ] Successful callback is idempotent.
- [ ] Promotion is committed before the success browser route loads.
- [ ] Failed payment does not activate promotion.
- [ ] Existing active promotion survives a separate failed payment.

### Android and iOS route checks

- [ ] Promotion success ends on an HTTPS URL containing lowercase `success`.
- [ ] Promotion failure/cancellation ends on an HTTPS URL containing lowercase
      `failed`.
- [ ] Online `subscribe-package` success ends on a URL containing lowercase
      `success`.
- [ ] Online `subscribe-package` failure/cancellation ends on a URL containing
      lowercase `failed`.
- [ ] Online `renew-package` follows the same rule.
- [ ] All final routes work inside the WebView on both Android and iOS.

## 12. Mobile files implementing this contract

- `lib/src/core/network/api_endpoints.dart`
- `lib/src/features/promotions/presentation/cubits/promotion_plans_cubit.dart`
- `lib/src/features/promotions/presentation/cubits/promotion_subscription_cubit.dart`
- `lib/src/features/promotions/data/models/promotion_plans_model.dart`
- `lib/src/features/promotions/data/models/promotion_subscription_model.dart`
- `lib/src/core/widgets/sheets/promotion_plans_sheet/promotion_plans_sheet_body.dart`
- `lib/src/features/packages/presentation/cubits/subscribe_to_package.dart`
- `lib/src/features/packages/presentation/screens/subscription_screen.dart`
- `lib/src/core/shared/models/user_models/user_model.dart`
- `lib/src/core/shared/models/user_models/parent/parent_model.dart`
- `lib/src/features/main_screen/data/models/home_model.dart`

