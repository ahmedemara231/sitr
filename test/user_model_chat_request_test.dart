import 'package:flutter_base/src/core/shared/models/user_models/individual/female_model.dart';
import 'package:flutter_base/src/core/shared/models/user_models/individual/male_model.dart';
import 'package:flutter_base/src/core/shared/models/user_models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> profileJson({
    String gender = 'male',
    bool? hasChatRequestFrom,
  }) {
    return {
      'id': 42,
      'type': {'title': 'Individual', 'value': 'individual'},
      'gender': {'title': gender, 'value': gender},
      'admin_approval_status': {'title': 'Approved', 'value': 'approved'},
      'can_chat': {'can_chat': true, 'reason': null},
      'has_active_package': false,
      if (hasChatRequestFrom != null)
        'has_chat_request_from': hasChatRequestFrom,
    };
  }

  test('parses and serializes has_chat_request_from', () {
    final UserModel user = UserModel.fromJson(
      profileJson(hasChatRequestFrom: true),
    );

    expect(user, isA<MaleModel>());
    expect(user.hasChatRequestFrom, isTrue);
    expect(user.toJson()['has_chat_request_from'], isTrue);
    expect(
        user.copyWith(hasChatRequestFrom: false).hasChatRequestFrom, isFalse);
  });

  test('defaults has_chat_request_from to false when omitted', () {
    final UserModel user = UserModel.fromJson(profileJson());

    expect(user.hasChatRequestFrom, isFalse);
  });

  test('parses has_chat_request_from for female profiles', () {
    final UserModel user = UserModel.fromJson(
      profileJson(
        gender: 'female',
        hasChatRequestFrom: true,
      ),
    );

    expect(user, isA<FemaleModel>());
    expect(user.hasChatRequestFrom, isTrue);
  });
}
