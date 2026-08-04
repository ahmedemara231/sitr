import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/res/config_imports.dart';
import 'promotion_plans_header_builder.dart';
import 'promotion_plans_view.dart';

class PromotionPlansBody extends StatelessWidget {
  final FutureOr<void> Function()? onSuccess;

  const PromotionPlansBody({
    this.onSuccess,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackShadow.withValues(alpha: 0.06),
                blurRadius: 24.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Column(
              children: [
                const PromotionPlansHeaderBuilder(showCloseButton: false),
                Expanded(
                  child: PromotionPlansView(onSuccess: onSuccess),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
