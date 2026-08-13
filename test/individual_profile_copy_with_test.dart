import 'package:flutter_base/src/core/helpers/user_type_enum.dart';
import 'package:flutter_base/src/core/shared/models/title_value_shape.dart';
import 'package:flutter_base/src/core/shared/models/user_models/individual/female_model.dart';
import 'package:flutter_base/src/core/shared/models/user_models/individual/individual_user_model.dart';
import 'package:flutter_base/src/core/shared/models/user_models/individual/male_model.dart';
import 'package:flutter_base/src/core/shared/models/user_models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const TitleValueShape custody = TitleValueShape(
    title: 'Parent',
    value: 'parent',
  );
  final ChildParentInfo parentInfo = ChildParentInfo(
    id: 4,
    name: 'Parent name',
    avatar: 'avatar.png',
  );

  test('male copyWith preserves subtype and inherited profile fields', () {
    final MaleModel model = MaleModel(
      id: 12,
      identityNumber: '1234567890',
      gender: GenderValueShape(userGender: UserGender.male),
      childParentInfo: parentInfo,
      nickName: 'Old nickname',
      hasChildren: true,
      numOfChildren: 2,
      childCustody: custody,
    );

    final MaleModel updated = model.copyWith(nickName: 'New nickname');

    expect(updated, isA<MaleModel>());
    expect(updated.nickName, 'New nickname');
    expect(updated.id, 12);
    expect(updated.identityNumber, '1234567890');
    expect(updated.childParentInfo, same(parentInfo));
    expect(updated.numOfChildren, 2);
    expect(updated.childCustody, custody);
  });

  test('female copyWith preserves subtype-specific values', () {
    final FemaleModel model = FemaleModel(
      gender: GenderValueShape(userGender: UserGender.female),
      childParentInfo: parentInfo,
      hijab: const TitleValueShape(title: 'Hijab', value: 'hijab'),
      acceptsPolygamy: false,
      preferredResidenceAfterMarriage: 'Riyadh',
    );

    final FemaleModel updated = model.copyWith(height: '165');

    expect(updated, isA<FemaleModel>());
    expect(updated.height, '165');
    expect(updated.hijab, model.hijab);
    expect(updated.acceptsPolygamy, isFalse);
    expect(updated.preferredResidenceAfterMarriage, 'Riyadh');
    expect(updated.childParentInfo, same(parentInfo));
  });

  test('copyWith explicitly clears child-dependent fields', () {
    final MaleModel model = MaleModel(
      hasChildren: true,
      numOfChildren: 3,
      childCustody: custody,
    );

    final MaleModel updated = model.copyWith(
      hasChildren: false,
      clearNumOfChildren: true,
      clearChildCustody: true,
    );

    expect(updated.hasChildren, isFalse);
    expect(updated.numOfChildren, isNull);
    expect(updated.childCustody, isNull);
  });
}
