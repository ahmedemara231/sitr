import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../../core/navigation/navigator.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/buttons/default_button.dart';

Future<void> showWhatsNewSheet({
  required List<String> items,
  required String version,
}) async {
  await showModalBottomSheet<void>(
    context: Go.context,
    isScrollControlled: true,
    backgroundColor: AppColors.transparent,
    barrierColor: AppColors.blackShadow.withValues(alpha: 0.45),
    builder: (_) => WhatsNewSheet(items: items, version: version),
  );
}

class WhatsNewSheet extends StatelessWidget {
  final List<String> items;
  final String version;

  const WhatsNewSheet({
    required this.items,
    required this.version,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackShadow.withValues(alpha: 0.12),
                  blurRadius: 32.r,
                  offset: Offset(0, -4.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _SheetChrome(),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 16.h),
                    child: Column(
                      children: [
                        _WhatsNewHeader(version: version),
                        SizedBox(height: 20.h),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.border,
                        ),
                        SizedBox(height: 20.h),
                        _FeaturesList(items: items),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.border,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
                  child: DefaultButton(
                    width: double.infinity,
                    height: 50.h,
                    borderRadius: BorderRadius.circular(50.r),
                    color: AppColors.primary,
                    title: LocaleKeys.whatsNewStartNow,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    onTap: Go.back,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetChrome extends StatelessWidget {
  const _SheetChrome();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(50.r),
            ),
          ),
          PositionedDirectional(
            top: 4.h,
            end: 8.w,
            child: IconButton(
              tooltip: LocaleKeys.close,
              onPressed: Go.back,
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.close_rounded,
                size: 22.r,
                color: const Color(0xFFAAAAAA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WhatsNewHeader extends StatelessWidget {
  final String version;

  const _WhatsNewHeader({required this.version});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52.r,
          height: 52.r,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFFFDF3E0),
            shape: BoxShape.circle,
          ),
          child: AppText('🎉', fontSize: 24.sp),
        ),
        SizedBox(height: 8.h),
        AppText(
          LocaleKeys.whatsNewTitle,
          color: AppColors.textBlack,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
          height: 1.3,
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFDF3E0),
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: AppText(
            '${LocaleKeys.whatsNewVersionLabel} $version',
            color: AppColors.primary,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 280.w),
          child: AppText(
            LocaleKeys.whatsNewDescription,
            color: AppColors.darkGay,
            fontSize: 13.sp,
            textAlign: TextAlign.center,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _FeaturesList extends StatelessWidget {
  final List<String> items;

  const _FeaturesList({required this.items});

  static const List<_FeatureVisual> _visuals = [
    _FeatureVisual(
      icon: Icons.bolt_rounded,
      backgroundColor: Color(0xFFFDF3E0),
      foregroundColor: AppColors.primary,
    ),
    _FeatureVisual(
      icon: Icons.auto_awesome_rounded,
      backgroundColor: Color(0xFFEDF4FF),
      foregroundColor: Color(0xFF2563EB),
    ),
    _FeatureVisual(
      icon: Icons.build_rounded,
      backgroundColor: Color(0xFFF0FDF4),
      foregroundColor: Color(0xFF16A34A),
    ),
    _FeatureVisual(
      icon: Icons.notifications_none_rounded,
      backgroundColor: Color(0xFFFDF2F8),
      foregroundColor: Color(0xFF9D174D),
    ),
    _FeatureVisual(
      icon: Icons.lock_outline_rounded,
      backgroundColor: Color(0xFFF5F3FF),
      foregroundColor: Color(0xFF6D28D9),
    ),
  ];

  List<String> get _titles => [
        LocaleKeys.whatsNewFasterExperience,
        LocaleKeys.whatsNewClearerDesign,
        LocaleKeys.whatsNewImprovementsAndFixes,
        LocaleKeys.whatsNewSmarterNotifications,
        LocaleKeys.whatsNewBetterPrivacy,
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.indexed
          .map(
            ((int, String) entry) => Padding(
              padding: EdgeInsets.only(
                bottom: entry.$1 == items.length - 1 ? 0 : 16.h,
              ),
              child: _FeatureItem(
                title: entry.$1 < _titles.length ? _titles[entry.$1] : entry.$2,
                description: entry.$1 < _titles.length ? entry.$2 : null,
                visual: _visuals[entry.$1 % _visuals.length],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String title;
  final String? description;
  final _FeatureVisual visual;

  const _FeatureItem({
    required this.title,
    required this.description,
    required this.visual,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: visual.backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            visual.icon,
            size: 19.r,
            color: visual.foregroundColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                color: AppColors.textBlack,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
              if (description != null) ...[
                SizedBox(height: 2.h),
                AppText(
                  description!,
                  color: AppColors.darkGay,
                  fontSize: 13.sp,
                  height: 1.6,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureVisual {
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  const _FeatureVisual({
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });
}
