import '../../../../../generated/assets.dart';
import '../../../../config/language/languages.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../extensions/bool.dart';
import '../../../extensions/string_extension.dart';
import '../../../shared/models/user_models/individual/female_model.dart';
import '../../../shared/models/user_models/individual/individual_user_model.dart';
import '../models/profile_detail_item_model.dart';
import '../models/profile_section_model.dart';

class ProfileSectionsMapper {
  const ProfileSectionsMapper._();

  static List<ProfileSectionModel> map({
    required IndividualUserModel profileUser,
    required bool isOwnProfile,
  }) {
    final FemaleModel? femaleUser =
        profileUser is FemaleModel ? profileUser : null;
    final List<List<ProfileDetailItemModel>> mainInformationRows = [
      if (isOwnProfile)
        [
          ProfileDetailItemModel(
            icon: Assets.assets.svg.user.path,
            label: LocaleKeys.name,
            value: _cleanValue(profileUser.name),
          ),
          ProfileDetailItemModel(
            icon: Assets.assets.svg.user.path,
            label: LocaleKeys.nickname,
            value: _cleanValue(profileUser.nickName),
          ),
        ],
      [
        ProfileDetailItemModel(
          icon: Assets.assets.svg.ageIcon.path,
          label: LocaleKeys.age,
          value: _valueWithSuffix(profileUser.age, LocaleKeys.years),
        ),
        ProfileDetailItemModel(
          icon: Assets.assets.svg.martialStatus.path,
          label: LocaleKeys.maritalStatus,
          value: _cleanValue(profileUser.maritalStatus?.title),
        ),
      ],
      if (isOwnProfile)
        [
          ProfileDetailItemModel(
            icon: Assets.assets.svg.profilePhone.path,
            label: LocaleKeys.phoneNumber,
            value: _cleanValue(profileUser.phone),
          ),
        ],
    ];

    final List<List<ProfileDetailItemModel>> familyRows = [
      [
        ProfileDetailItemModel(
          icon: Assets.assets.svg.parentChildren.path,
          label: LocaleKeys.childrenExists,
          value: profileUser.hasChildren?.toNormalLang(),
        ),
        ProfileDetailItemModel(
          icon: Assets.assets.svg.parentChildren.path,
          label: LocaleKeys.wantToHaveChildren,
          value: profileUser.wantChildren?.toNormalLang(),
        ),
      ],
      if (profileUser.hasChildren == true)
        [
          ProfileDetailItemModel(
            icon: Assets.assets.svg.parentChildren.path,
            label: LocaleKeys.childrenNumber,
            value: _valueWithSuffix(
              profileUser.numOfChildren,
              LocaleKeys.children,
            ),
          ),
          ProfileDetailItemModel(
            icon: Assets.assets.svg.parentChildren.path,
            label: LocaleKeys.nursery,
            value: _cleanValue(profileUser.childCustody?.title),
          ),
        ],
      [
        ProfileDetailItemModel(
          icon: Assets.assets.svg.walletPay.path,
          label: LocaleKeys.dowry,
          value: _formatDowry(profileUser),
        ),
        ProfileDetailItemModel(
          icon: Assets.assets.svg.recycing.path,
          label: LocaleKeys.typeOfWeddingParty,
          value: _cleanValue(profileUser.weddingType?.title),
        ),
      ],
      if (femaleUser != null)
        [
          ProfileDetailItemModel(
            icon: Assets.assets.svg.home.path,
            label: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
            value: _cleanValue(femaleUser.preferredResidenceAfterMarriage),
          ),
        ],
      if (femaleUser != null)
        [
          ProfileDetailItemModel(
            icon: Assets.assets.svg.parentChildren.path,
            label: LocaleKeys.doYouAcceptPolygamy,
            value: femaleUser.acceptsPolygamy?.toNormalLang(),
          ),
        ],
    ];

    return [
      ProfileSectionModel(
        title: LocaleKeys.mainInformation,
        rows: mainInformationRows,
      ),
      ProfileSectionModel(
        title: LocaleKeys.personalDetails,
        rows: [
          [
            ProfileDetailItemModel(
              icon: Assets.assets.svg.tallIcon.path,
              label: LocaleKeys.tall,
              value: _valueWithSuffix(
                profileUser.height,
                LocaleKeys.centimeter,
              ),
            ),
            ProfileDetailItemModel(
              icon: Assets.assets.svg.weight.path,
              label: LocaleKeys.weight,
              value: _valueWithSuffix(profileUser.weight, LocaleKeys.kg),
            ),
          ],
          [
            ProfileDetailItemModel(
              icon: Assets.assets.svg.location.path,
              label: LocaleKeys.city,
              value: _cleanValue(profileUser.cityId?.name),
            ),
          ],
          [
            ProfileDetailItemModel(
              icon: Assets.assets.svg.educationalQualification.path,
              label: LocaleKeys.educationalQualification,
              value: _cleanValue(profileUser.educationLevel),
            ),
            ProfileDetailItemModel(
              icon: Assets.assets.svg.job.path,
              label: LocaleKeys.currentJob,
              value: _cleanValue(profileUser.currentJob),
            ),
          ],
          // [
          //   ProfileDetailItemModel(
          //     icon: Assets.assets.svg.user.path,
          //     label: LocaleKeys.quickBrief,
          //     value: _cleanValue(profileUser.bio),
          //   ),
          // ],
        ],
      ),
      ProfileSectionModel(
        title: LocaleKeys.familyAndMarriage,
        rows: familyRows,
      ),
      ProfileSectionModel(
        title: LocaleKeys.lifestyleAndHealth,
        rows: [
          [
            ProfileDetailItemModel(
              icon: Assets.assets.svg.smoke.path,
              label: LocaleKeys.areYouSmoke,
              value: profileUser.isSmoker?.toNormalLang(),
            ),
            ProfileDetailItemModel(
              icon: Assets.assets.svg.tribe.path,
              label: LocaleKeys.doYouBelongToATribe,
              value: profileUser.tribeAffiliation?.toNormalLang(),
            ),
          ],
          [
            ProfileDetailItemModel(
              icon: Assets.assets.svg.parentIcon.path,
              label: LocaleKeys.skinColor,
              value: _cleanValue(profileUser.skinColor?.title),
            ),
            ProfileDetailItemModel(
              icon: Assets.assets.svg.translation.path,
              label: LocaleKeys.inChatYouPrefer,
              value: _cleanValue(
                profileUser.chatLang?.toLang().toFullTitle(),
              ),
            ),
          ],
          [
            ProfileDetailItemModel(
              icon: Assets.assets.svg.hospital.path,
              label: LocaleKeys.diseasesIfExists,
              value: _cleanValue(profileUser.healthConditions),
            ),
          ],
        ],
      ),
      ProfileSectionModel(
        title: LocaleKeys.faithAndPreferences,
        rows: [
          [
            ProfileDetailItemModel(
              icon: Assets.assets.svg.prey.path,
              label: LocaleKeys.areYouPray,
              value: profileUser.isPrayer?.toNormalLang(),
            ),
            ProfileDetailItemModel(
              icon: Assets.assets.svg.prey.path,
              label: LocaleKeys.degreeOfCommitment,
              value: _cleanValue(profileUser.religiousCommitment?.title),
            ),
          ],
          if (femaleUser != null)
            [
              ProfileDetailItemModel(
                icon: Assets.assets.svg.hijab.path,
                label: LocaleKeys.areYouWaringHijab,
                value: _cleanValue(femaleUser.hijab?.title),
              ),
            ],
          [
            ProfileDetailItemModel(
              icon: Assets.assets.svg.forbidden.path,
              label: LocaleKeys.thingsIAbsolutelyDoNotAcceptOrWant,
              value: _cleanValue(profileUser.prohibitedThings),
            ),
          ],
        ],
      ),
    ];
  }

  static String? _cleanValue(Object? value) {
    if (value == null) {
      return null;
    }
    final String text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String? _valueWithSuffix(Object? value, String suffix) {
    final String? cleanValue = _cleanValue(value);
    return cleanValue == null ? null : '$cleanValue $suffix';
  }

  static String? _formatDowry(IndividualUserModel profileUser) {
    final String? minimum = _cleanValue(profileUser.dowry?.from);
    final String? maximum = _cleanValue(profileUser.dowry?.to);
    if (minimum == null && maximum == null) {
      return null;
    }
    if (minimum == null) {
      return '${LocaleKeys.to} $maximum';
    }
    if (maximum == null) {
      return '${LocaleKeys.from} $minimum';
    }
    return '${LocaleKeys.from} $minimum ${LocaleKeys.to} $maximum';
  }
}
