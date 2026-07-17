# Promotion Badge API Contract

## App Integration Summary

- Endpoint constant: `ApiConstants.profilePromotionPlans`
- Endpoint path: `profile-promotion-plans`
- Method: `GET`
- Subscribe endpoint constant: `ApiConstants.profilePromotionSubscribtion`
- Subscribe endpoint path: `profile_promotion_subscribtion`
- Cubits: `PromotionPlansCubit`, `PromotionSubscriptionCubit`
- Model file: `lib/src/features/promotions/data/models/promotion_plans_model.dart`
- Subscribe model file: `lib/src/features/promotions/data/models/promotion_subscription_model.dart`
- UI consumer: `lib/src/core/widgets/sheets/promotion_plans_sheet.dart`
- Payment screen: `lib/src/features/packages/presentation/screens/subscription_screen.dart`
- Payment success sheet: `lib/src/core/widgets/sheets/success_sheet.dart`

## Fetch Plans Endpoint

`GET profile-promotion-plans`

The app expects the standard API wrapper used in this project.

```json
{
  "key": "success",
  "msg": "Promotion plans loaded successfully",
  "data": {
    "plans": [
      {
        "id": 1,
        "code": "monthly",
        "duration": "شهر واحد",
        "price": 29,
        "currency": "ريال",
        "period": "شهرياً",
        "description": "جرّب المميزات الأساسية بدون قيود",
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
        "currency": "ريال",
        "period": "كل 3 أشهر",
        "description": "الأكثر شيوعاً - وفّر 21% مقارنةً بالشهري",
        "badge": "الأكثر طلباً",
        "is_highlighted": true,
        "is_default": true,
        "sort_order": 2
      }
    ],
    "features": [
      {
        "id": 1,
        "code": "search_priority",
        "title": "ظهور ملفك في نتائج البحث الأولى",
        "sort_order": 1
      }
    ]
  }
}
```

## Subscribe Endpoint

`POST profile_promotion_subscribtion`

Request body:

```json
{
  "plan_id": 2
}
```

Expected response:

```json
{
  "key": "success",
  "msg": "Payment link generated successfully",
  "data": {
    "link": "https://payment-gateway.example/checkout/session-id"
  }
}
```

The app reads `data.link`; aliases accepted: `redirect_url`, `url`.

After receiving `link`, the app opens `SubscriptionScreen(initialUrl: link)`. When that screen returns `success`, the backend must have updated the authenticated user so `is_promoted` is `true`. The app then calls `GET profile`, parses `UserModel.fromJson`, and persists the result with `UserCubit.updateUser`.

## Database-Backed Fields

### `plans`

- `id` (`int`, required): plan/package id used for selection.
- `code` (`string`, recommended): stable backend identifier such as `monthly`, `quarterly`, `annual`.
- `duration` (`string`, required): visible plan duration.
- `price` (`number`, required): visible price.
- `currency` (`string`, required): vaisible currency label.
- `period` (`string`, required): billing cadence without the leading slash; the app renders `/ {period}`.
- `description` (`string`, required): plan helper text.
- `badge` (`string|null`): optional badge label.
- `is_highlighted` (`bool`): styles badge/card as highlighted.
- `is_default` (`bool`): selected by default when the sheet opens.
- `sort_order` (`int`): display order.

### `features`

- `id` (`int`, required): feature id.
- `code` (`string`, recommended): stable feature identifier.
- `title` (`string`, required): visible feature text.
- `sort_order` (`int`): display order.

## `fromJson` Keys And Aliases

The app reads `data.plans`; aliases accepted: `promotion_plans`, `packages`.

Plan keys:

- `id`; aliases: `plan_id`, `package_id`
- `code`; aliases: `slug`, `key`
- `duration`; aliases: `title`, `name`
- `price`; alias: `amount`
- `currency`
- `period`; aliases: `per`, `billing_period`
- `description`; aliases: `desc`, `subtitle`
- `badge`; aliases: `label`, `tag`
- `is_highlighted`; aliases: `highlight`, `is_popular`
- `is_default`; aliases: `default`, `selected_by_default`
- `sort_order`; alias: `order`

The app reads `data.features`; aliases accepted: `promotion_features`, `benefits`.

Feature keys:

- `id`; alias: `feature_id`
- `code`; aliases: `slug`, `key`
- `title`; aliases: `name`, `description`
- `sort_order`; alias: `order`

Subscription response keys:

- `link`; aliases: `redirect_url`, `url`

User refresh key:

- `is_promoted` (`bool`): must be `true` in the `GET profile` response after successful payment.
