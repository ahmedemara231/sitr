import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/validation_helper.dart';
import '../../../../more/presentation/cubit/terms_condition_and_about_cubit/terms_condition_and_about_cubit.dart';
import '../../../../more/presentation/screens/terms_andcondition_and_about_us/terms_andcondition_and_about_us.dart';

class ConditionsTermsAcceptance extends StatefulWidget {
  final void Function(bool isAccepted) onAcceptanceChanged;

  const ConditionsTermsAcceptance({
    required this.onAcceptanceChanged,
    super.key,
  });

  @override
  State<ConditionsTermsAcceptance> createState() =>
      _ConditionsTermsAcceptanceState();
}

class _ConditionsTermsAcceptanceState extends State<ConditionsTermsAcceptance> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return ValidationHost<bool>(
      onSaved: (value) {},
      validator: (value) =>
          _isAccepted ? null : LocaleKeys.pleaseAcceptTheConditionsAndTerms,
      initialValue: false,
      builderWidget: (accepted) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                activeColor: AppColors.primary,
                value: _isAccepted,
                onChanged: (bool? value) {
                  final bool isAccepted = value ?? false;
                  setState(() => _isAccepted = isAccepted);
                  accepted.didChange(isAccepted);
                  widget.onAcceptanceChanged(isAccepted);
                },
              ),
              AppText(
                LocaleKeys.iHaveReadAndAccept,
                fontSize: 12.sp,
                color: Colors.grey,
              ),
              TextButton(
                onPressed: () => Go.to(
                  const TermsAndConditionAndAboutUs(
                    staticPageType: StaticPageType.terms,
                  ),
                ),
                child: AppText(
                  LocaleKeys.conditionsAndTerms,
                  fontSize: 12.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (accepted.hasError)
            AppText(accepted.errorText ?? '', color: Colors.red),
        ],
      ),
    );
  }
}
