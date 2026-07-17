part of '../../../imports.dart';

class _ChildDataForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final ValueNotifier<UserGender> mainType;
  final bool withParent;
  final bool showInlineGenderSelection;
  final bool showBackButton;
  final bool showConditionsAndTerms;
  final bool showAlreadyHaveAccount;
  final IndividualUserModel? initialValue;
  final int? maleNum;
  final int? femaleNum;
  final void Function(UserGender gender) onGenderSelected;
  final void Function(File? img) onImageSelected;
  final void Function(UserGender gender) onGenderFieldsResolved;
  final void Function(IndividualUserModel data) onDataChanged;
  final Future<void> Function() onBackPressed;
  final Future<void> Function(BuildContext context) onSubmitPressed;

  const _ChildDataForm({
    required this.formKey,
    required this.mainType,
    required this.withParent,
    required this.showInlineGenderSelection,
    required this.showConditionsAndTerms,
    required this.showAlreadyHaveAccount,
    required this.initialValue,
    required this.maleNum,
    required this.femaleNum,
    required this.onGenderSelected,
    required this.onImageSelected,
    required this.onGenderFieldsResolved,
    required this.onDataChanged,
    required this.onBackPressed,
    required this.onSubmitPressed,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 10.h,
        children: [
          if (showInlineGenderSelection)
            ChooseGenderWidget(
              titles: (element) =>
                  '${element.translate}  ${element.isFemale ? femaleNum : maleNum}',
              canChoose: true,
              onSelectGender: onGenderSelected,
              genders: const [
                UserGender.male,
                UserGender.female,
              ],
            ),
          if (withParent)
            SelectImageWidget(
              initialValue: initialValue?.avatar,
              onSelectImage: onImageSelected,
            ),
          ValueListenableBuilder(
            valueListenable: mainType,
            builder: (context, type, child) {
              onGenderFieldsResolved(type);
              if (type.isFemale) {
                return FemaleFields(
                  withParent: withParent,
                  initialValue: initialValue,
                  onChangeFemaleData: onDataChanged,
                );
              } else if (type.isMale) {
                return MaleFields(
                  initialValue: initialValue,
                  withParent: withParent,
                  onChangeMaleData: onDataChanged,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          if (showConditionsAndTerms) const ConditionsTermsAcceptance(),
          if (showBackButton)
            Row(
              children: [
                Expanded(
                  child: DefaultButton(
                    title: LocaleKeys.back,
                    borderRadius: BorderRadius.circular(10.r),
                    height: 45.h,
                    width: double.infinity,
                    color: AppColors.white,
                    borderColor: AppColors.primary,
                    textColor: AppColors.primary,
                    onTap: () async => await onBackPressed(),
                  ),
                ),
                10.szW,
                Expanded(
                  child: AppLoadingButton(
                    height: 45.h,
                    borderRadius: 10.r,
                    title: LocaleKeys.confirm,
                    asyncCall: onSubmitPressed,
                  ),
                ),
              ],
            )
          else
            AppLoadingButton(
              height: 45.h,
              borderRadius: ConstantManager.buttonBorderRadiusNumber,
              title: LocaleKeys.confirm,
              asyncCall: onSubmitPressed,
            ),
          if (showAlreadyHaveAccount) const AlreadyHaveAccWidget()
        ],
      ),
    );
  }
}
