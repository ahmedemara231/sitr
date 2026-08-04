import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../features/promotions/data/models/promotion_data_model.dart';
import '../../../../features/promotions/data/models/promotion_plans_model.dart';
import '../../app_text.dart';
import 'promotion_features_list.dart';
import 'promotion_plan_card.dart';
import 'promotion_subscribe_button.dart';

class PromotionPlansContent extends StatelessWidget {
  final PromotionPlansModel data;
  final PromotionSheetDataModel content;
  final int? selectedPlanId;
  final bool isSubscribing;
  final bool isSubscribed;
  final ValueChanged<PromotionPlanModel> onPlanSelected;
  final ValueChanged<PromotionPlanModel> onSubscribe;

  const PromotionPlansContent({
    required this.data,
    required this.content,
    required this.selectedPlanId,
    required this.isSubscribing,
    required this.isSubscribed,
    required this.onPlanSelected,
    required this.onSubscribe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final int currentPlanId = selectedPlanId ?? data.defaultPlan.id;
    final PromotionPlanModel selectedPlan = data.plans.firstWhere(
      (PromotionPlanModel plan) => plan.id == currentPlanId,
      orElse: () => data.defaultPlan,
    );

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PromotionPlansList(
            plans: data.plans,
            selectedPlanId: currentPlanId,
            onPlanSelected: onPlanSelected,
          ),
          SizedBox(height: 2.h),
          PromotionFeaturesList(
            title: _contentOrFallback(
              content.featureIntro,
              () => LocaleKeys.promotionSheetFeatureIntro,
            ),
            features: data.features,
          ),
          SizedBox(height: 18.h),
          PromotionSubscribeButton(
            title: _buildSubscribeButtonText(
              content: content,
              plan: selectedPlan,
            ),
            successTitle: _contentOrFallback(
              content.subscribedSuccessText,
              () => LocaleKeys.promotionSheetSubscribedSuccess,
            ),
            isLoading: isSubscribing,
            isDone: isSubscribed,
            onTap: () => onSubscribe(selectedPlan),
          ),
          SizedBox(height: 8.h),
          AppText(
            _contentOrFallback(
              content.cancelAnytimeText,
              () => LocaleKeys.promotionSheetCancelAnytime,
            ),
            textAlign: TextAlign.center,
            color: AppColors.hintText,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

String _buildSubscribeButtonText({
  required PromotionSheetDataModel content,
  required PromotionPlanModel plan,
}) {
  if (content.subscribeButtonTemplate.trim().isNotEmpty) {
    return content.subscribeButtonTemplate
        .replaceAll('{duration}', plan.duration)
        .replaceAll('{price}', plan.priceText)
        .replaceAll('{currency}', plan.currency);
  }

  return '${LocaleKeys.promotionSheetSubscribePrefix} '
      '${plan.duration} - ${plan.priceText} ${plan.currency}';
}

String _contentOrFallback(String content, String Function() fallback) =>
    content.trim().isEmpty ? fallback() : content;
