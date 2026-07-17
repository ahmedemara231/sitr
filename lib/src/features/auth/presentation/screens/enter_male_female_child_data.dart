part of '../../imports.dart';

enum ScaffoldType { appScaffold, centerCard }

class EnterMaleOrFemaleOrChildDataScreen extends StatelessWidget {
  final ScaffoldType scaffoldType;
  final IndividualUserModel? initialValue;
  final bool _withParent;
  final bool showConditionsAndTerms;
  final bool showAlreadyHaveAccount;
  final UserGender? userType;
  final bool showGenderSelection;
  final int? maleNum;
  final int? femaleNum;

  final Future<void> Function(BuildContext context, IndividualUserModel user)
      onClick;

  const EnterMaleOrFemaleOrChildDataScreen.showAll({
    super.key,
    required this.scaffoldType,
    required this.onClick,
    this.showGenderSelection = true,
    this.initialValue,
    this.maleNum = 0,
    this.femaleNum = 0,
    this.showConditionsAndTerms = false,
    this.showAlreadyHaveAccount = false,
    this.userType,
  }) : _withParent = true;

  const EnterMaleOrFemaleOrChildDataScreen.individual({
    super.key,
    required this.scaffoldType,
    this.showGenderSelection = false,
    this.initialValue,
    required this.onClick,
    this.showConditionsAndTerms = false,
    this.showAlreadyHaveAccount = false,
    required this.userType,
  })  : _withParent = false,
        maleNum = null,
        femaleNum = null;

  @override
  Widget build(BuildContext context) {
    return scaffoldType == ScaffoldType.appScaffold
        ? AppScaffold(
      isScrollable: true,
            appBarTitle: LocaleKeys.profile,
            body: _EnterMaleOrFemaleOrChildDataBody(
              maleNum: maleNum,
              femaleNum: femaleNum,
              userType: userType,
              withParent: _withParent,
              showGenderSelection: showGenderSelection,
              initialValue: initialValue,
              showAlreadyHaveAccount: showAlreadyHaveAccount,
              showConditionsAndTerms: showConditionsAndTerms,
              onClick: onClick,
            ))
        : CenterCardScaffold(
            upperWidget: const SignUpUpperWidget(),
            bodyColor: AppColors.white,
            body: _EnterMaleOrFemaleOrChildDataBody(
              maleNum: maleNum,
              femaleNum: femaleNum,
              withParent: _withParent,
              showGenderSelection: showGenderSelection,
              userType: userType,
              initialValue: initialValue,
              showAlreadyHaveAccount: showAlreadyHaveAccount,
              showConditionsAndTerms: showConditionsAndTerms,
              onClick: onClick,
            ));
  }
}
