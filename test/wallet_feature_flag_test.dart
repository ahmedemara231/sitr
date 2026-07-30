import 'package:flutter_base/src/config/res/config_imports.dart';
import 'package:flutter_base/src/core/widgets/sheets/payment_sheet.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => FeatureFlags.setRemoveWallet(false));

  test('wallet remains available when removeWallet is false', () {
    FeatureFlags.setRemoveWallet(false);

    expect(FeatureFlags.isWalletAvailable, isTrue);
    expect(
      PaymentMethod.availableMethods(),
      PaymentMethod.values,
    );
  });

  test('wallet is removed from payment methods when removeWallet is true', () {
    FeatureFlags.setRemoveWallet(true);

    expect(FeatureFlags.isWalletAvailable, isFalse);
    expect(
      PaymentMethod.availableMethods(),
      const <PaymentMethod>[PaymentMethod.online],
    );
    expect(
      PaymentMethod.availableMethods(
        methods: const <PaymentMethod>[PaymentMethod.wallet],
      ),
      isEmpty,
    );
  });
}
