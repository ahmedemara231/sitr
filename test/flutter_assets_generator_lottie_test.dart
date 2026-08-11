import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_base/generated/assets.dart';
import 'package:lottie/lottie.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generated incomplete profile asset exists and loads', () async {
    final LottieGenImage asset = Assets.assets.lottie.data.incompleteProfile;
    final ByteData bytes = await rootBundle.load(asset.path);
    final LottieComposition composition = await LottieComposition.fromBytes(
      bytes.buffer.asUint8List(),
    );

    expect(asset.path, 'assets/lottie/data/incomplete_profile.json');
    expect(bytes.lengthInBytes, greaterThan(0));
    expect(composition.bounds.width, 512);
    expect(composition.bounds.height, 512);
  });
}
