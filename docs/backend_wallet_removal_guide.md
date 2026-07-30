# Backend Guide: Remove Wallet-Balance Conditions

## Objective

The mobile app now uses the Firebase Remote Config boolean `removeWallet`.

- `removeWallet = true`: the app hides the wallet, removes wallet payment
  choices, blocks wallet requests, and hides wallet notifications.
- `removeWallet = false`: the existing wallet behavior remains available.

The backend must also stop using wallet balance as a condition for user
eligibility or for non-wallet operations. The client-side flag is not a
security boundary, so the backend must safely handle requests from older app
versions that may still expose the wallet.

## Required backend behavior

### 1. Account deletion safety

Endpoint:

```text
GET delete_safety
```

Remove every condition that blocks account deletion because:

- the user has a wallet;
- the wallet exists but has no balance;
- the wallet balance is greater than zero;
- the wallet has pending credit or debit operations.

Wallet balance must not affect the `is_safe.value` result.

Keep unrelated safety rules, such as:

- an active package;
- an active/live chat;
- any other business blocker unrelated to the wallet.

Expected examples:

| User state | Expected result |
|---|---|
| Wallet balance is `0`, no other blocker | Safe to delete |
| Wallet balance is positive, no other blocker | Safe to delete |
| Wallet is missing/null, no other blocker | Safe to delete |
| Active package exists | Unsafe with `has_active_package` |
| Active chat exists | Unsafe with `has_live_chat` |

Do not return a wallet-related reason such as `wallet_balance`,
`has_wallet_balance`, or `insufficient_wallet_balance`.

If account deletion is allowed while historical funds still exist, preserve
the financial ledger according to the agreed retention/anonymization policy.
Do not silently erase or zero financial records merely to pass this check.

### 2. Package subscription and renewal

Endpoints:

```text
POST subscribe-package
POST renew-package
```

The supported mobile flow while the wallet is removed is online payment:

```json
{
  "package_id": 1,
  "payment_method": "online",
  "brand_id": 1
}
```

For online payments:

- do not load the user's wallet;
- do not require a wallet record;
- do not check the wallet balance;
- do not reject the operation because the balance is null, zero, or
  insufficient;
- continue returning the online payment `redirect_url`.

If an older client sends `"payment_method": "wallet"`, return a controlled
validation/feature-disabled response. Do not debit the wallet and do not
silently change the request to online payment.

Recommended response:

```json
{
  "key": "wallet_disabled",
  "msg": "Wallet payment is no longer available.",
  "data": null
}
```

A `422 Unprocessable Entity` response is recommended unless the project has a
different standard status for disabled features.

### 3. Paid chat or match requests

Endpoint:

```text
POST pay-request/{userRequest}
```

For `"payment_method": "online"`:

- do not query or validate wallet balance;
- continue using `brand_id`;
- continue returning the payment `redirect_url`;
- allow the request regardless of whether a wallet record exists.

For `"payment_method": "wallet"`, return the same controlled
`wallet_disabled` response used by package payments.

### 4. Wallet endpoints

Wallet endpoints currently used by older clients:

```text
GET show-wallet
POST charge-wallet
```

When the backend wallet feature is disabled:

- do not allow new wallet charges;
- do not create wallet records automatically;
- do not return a usable payment redirect from `charge-wallet`;
- return a stable feature-disabled response instead of an internal error.

Keep these routes temporarily if old production app versions may still call
them. They can be removed after the minimum supported app version no longer
contains wallet functionality.

### 5. Wallet notifications

Stop producing the notification type:

```text
wallet_charged
```

Also remove wallet notifications from:

- queued notification jobs;
- notification retries;
- notification-list API results;
- unread notification and badge counts;
- email, SMS, or admin-triggered notification flows.

Already-created historical notifications may remain stored for audit purposes,
but they should not be delivered again.

### 6. Other wallet-dependent conditions

Search all backend services, controllers, policies, validators, jobs, listeners,
and admin actions for:

```text
wallet
wallet_id
wallet_balance
balance
available_balance
insufficient_balance
has_balance
payment_method = wallet
wallet_charged
charge-wallet
show-wallet
```

Remove wallet-balance checks from every non-wallet workflow. In particular,
check for:

- middleware or policies that require a wallet record;
- model observers that automatically create wallets;
- package or chat eligibility services;
- account deletion services;
- refunds, bonuses, promotions, and referral credits;
- scheduled jobs that expire or reconcile wallet funds;
- payment webhooks that credit a wallet;
- admin-panel actions that modify wallet balances;
- serializers that require wallet or balance fields;
- database queries using wallet balance to filter eligible users.

## Recommended server-side feature flag

Do not depend directly on the mobile Firebase value. Add a backend-controlled
flag, for example:

```text
WALLET_ENABLED=false
```

Use it to:

- reject legacy wallet requests consistently;
- stop wallet jobs and notifications;
- prevent wallet credits/debits;
- keep online payment flows independent of wallet data.

The flag should default to the safest value for each deployment environment and
must be included in deployment configuration.

## Existing balances and financial records

Before deleting wallet tables, columns, or ledger entries:

1. Export users with non-zero balances.
2. Reconcile pending wallet transactions and payment webhooks.
3. Decide whether remaining value will be refunded, converted, frozen, or
   handled manually.
4. Preserve the audit trail required by the business and applicable retention
   policy.
5. Disable new wallet mutations before migrating historical records.

Removing wallet conditions does not authorize deleting financial history.

## Rollout order

1. Deploy backend compatibility changes and the backend wallet flag.
2. Confirm online package and chat payments no longer access wallet data.
3. Disable wallet writes, jobs, and notifications.
4. Publish Firebase Remote Config `removeWallet = true`.
5. Monitor validation errors, old-client wallet calls, and payment success
   rates.
6. Reconcile historical balances.
7. Remove legacy wallet routes and schema only after old clients are no longer
   supported and financial cleanup is complete.

## Acceptance checklist

- [ ] A user with a positive wallet balance can pass `delete_safety` when no
      other blocker exists.
- [ ] A missing wallet record does not break account deletion.
- [ ] Online package subscription succeeds for null, zero, and positive legacy
      balances.
- [ ] Online package renewal succeeds for null, zero, and positive legacy
      balances.
- [ ] Online paid chat requests succeed without loading wallet data.
- [ ] Legacy `"payment_method": "wallet"` requests return a controlled
      `wallet_disabled` response.
- [ ] `show-wallet` and `charge-wallet` cannot perform wallet operations while
      the feature is disabled.
- [ ] No `wallet_charged` notifications are generated or counted.
- [ ] No background job credits, debits, or creates wallets.
- [ ] Online payment webhooks do not credit a wallet.
- [ ] Existing financial records are retained or migrated according to the
      approved reconciliation plan.
- [ ] Automated tests cover all cases above.

## Definition of done

The backend work is complete when a user's wallet record and balance can be
null, zero, or positive without changing the outcome of any non-wallet
workflow, while all direct wallet operations are consistently disabled and
historical financial data remains safely accounted for.
