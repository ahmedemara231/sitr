import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../config/res/config_imports.dart';
import '../../navigation/navigator.dart';
import '../app_text.dart';
import '../buttons/app_loading_button.dart';
import '../default_bottom_sheet.dart';
import '../icon_widget.dart';

Future<void> showAnnouncementSheet({
  FutureOr<void> Function()? onActionPressed,
  FutureOr<void> Function(String url)? onLinkPressed,
  String? actionTitle
}) async {
  await showDefaultBottomSheet(
    child: AnnouncementSheet(
      onActionPressed: onActionPressed,
      onLinkPressed: onLinkPressed,
      actionTitle: actionTitle,
    ),
  );
}

/// Presents rich announcement content exported from Word as HTML.
///
/// Plain extracted text is also supported; its line breaks are converted into
/// paragraphs before rendering. A `.doc` or `.docx` file must be converted to
/// HTML or text before it is passed to this widget.
class AnnouncementSheet extends StatelessWidget {
  final FutureOr<void> Function()? onActionPressed;
  final FutureOr<void> Function(String url)? onLinkPressed;
  final String? actionTitle;

  const AnnouncementSheet({
    this.onActionPressed,
    this.onLinkPressed,
    this.actionTitle,
    super.key,
  });

  Future<void> _handleAction() async {
    if (onActionPressed == null) {
      Go.back();
      return;
    }

    await onActionPressed!.call();
  }

  Future<void> _handleLink(String url) async {
    if (onLinkPressed != null) {
      await onLinkPressed!.call(url);
      return;
    }

    final Uri? parsedUri = Uri.tryParse(url);
    final Uri? uri =
        parsedUri?.hasScheme == true ? parsedUri : Uri.tryParse('https://$url');
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.sizeOf(context).height * 0.88;
    final TextDirection direction = Directionality.of(context);

    const String htmlContent = '''
  <h2>انتهاء الفترة التجريبية المجانية</h2>

  <p>
    نود إبلاغك بأن الفترة التجريبية المجانية للتطبيق قد انتهت.
  </p>

  <p>
    يرجى الاشتراك الآن في إحدى الباقات المتاحة لتتمكن من
    <strong>فتح محادثات جديدة</strong>
    والاستفادة من جميع مزايا التطبيق.
  </p>
  ''';

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Container(
            key: const Key('announcement_sheet'),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackShadow.withValues(alpha: 0.10),
                  blurRadius: 32.r,
                  offset: Offset(0, -4.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _AnnouncementSheetHandle(),
                _AnnouncementHeader(
                  title: LocaleKeys.announcement,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.border,
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      16.w,
                      16.h,
                      16.w,
                      18.h,
                    ),
                    child: _AnnouncementWordContent(
                      wordContent: htmlContent,
                      direction: direction,
                      onLinkPressed: (String url) {
                        unawaited(_handleLink(url));
                      },
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.border,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    16.w,
                    12.h,
                    16.w,
                    8.h,
                  ),
                  child: AppLoadingButton(
                    title: actionTitle ?? LocaleKeys.close,
                    asyncCall: (_) => _handleAction(),
                    height: 54.h,
                    borderRadius: 50.r,
                    fontSize: 14.sp,
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

class _AnnouncementSheetHandle extends StatelessWidget {
  const _AnnouncementSheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 4.h,
      margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(50.r),
      ),
    );
  }
}

class _AnnouncementHeader extends StatelessWidget {
  final String title;

  const _AnnouncementHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 4.h, 16.w, 14.h),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
            alignment: Alignment.center,
            child: IconWidget(
              icon: Icons.campaign_outlined,
              color: AppColors.primary,
              width: 22.r,
              height: 22.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: AppText(
              title,
              color: AppColors.textBlack,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 10.w),
          Semantics(
            button: true,
            label: LocaleKeys.close,
            child: Material(
              color: AppColors.whiteGreyColor,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: Go.back,
                child: SizedBox.square(
                  dimension: 36.r,
                  child: IconWidget(
                    icon: Icons.close_rounded,
                    color: AppColors.darkGay,
                    width: 18.r,
                    height: 18.r,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnnouncementWordContent extends StatelessWidget {
  final String wordContent;
  final TextDirection direction;
  final void Function(String url) onLinkPressed;

  const _AnnouncementWordContent({
    required this.wordContent,
    required this.direction,
    required this.onLinkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('announcement_word_content'),
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.whiteGreyColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: html.Html(
        data: _prepareWordContent(wordContent),
        onLinkTap: (url, _, __) {
          if (url != null && url.trim().isNotEmpty) {
            onLinkPressed(url.trim());
          }
        },
        style: _wordContentStyles(direction),
      ),
    );
  }
}

Map<String, html.Style> _wordContentStyles(TextDirection direction) => {
      'body': html.Style(
        color: AppColors.darkGray,
        direction: direction,
        fontFamily: ConstantManager.fontFamily,
        fontSize: html.FontSize(14.sp),
        lineHeight: const html.LineHeight(1.7),
        margin: html.Margins.zero,
        padding: html.HtmlPaddings.zero,
      ),
      'p': html.Style(
        margin: html.Margins.only(bottom: 10.h),
      ),
      'h1': _headingStyle(fontSize: 22.sp),
      'h2': _headingStyle(fontSize: 20.sp),
      'h3': _headingStyle(fontSize: 18.sp),
      'h4': _headingStyle(fontSize: 16.sp),
      'ul': html.Style(
        margin: html.Margins.only(bottom: 10.h),
        padding: html.HtmlPaddings.only(inlineStart: 18.w),
      ),
      'ol': html.Style(
        margin: html.Margins.only(bottom: 10.h),
        padding: html.HtmlPaddings.only(inlineStart: 18.w),
      ),
      'li': html.Style(
        margin: html.Margins.only(bottom: 6.h),
      ),
      'blockquote': html.Style(
        color: AppColors.darkGay,
        backgroundColor: AppColors.white,
        margin: html.Margins.symmetric(vertical: 10.h),
        padding: html.HtmlPaddings.all(12.r),
        border: Border.all(color: AppColors.border),
      ),
      'a': html.Style(
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
        textDecoration: TextDecoration.underline,
      ),
    };

html.Style _headingStyle({required double fontSize}) => html.Style(
      color: AppColors.textBlack,
      fontFamily: ConstantManager.fontFamily,
      fontSize: html.FontSize(fontSize),
      fontWeight: FontWeight.bold,
      lineHeight: const html.LineHeight(1.4),
      margin: html.Margins.only(bottom: 8.h),
    );

String _prepareWordContent(String content) {
  final String normalizedContent = content.trim();
  if (normalizedContent.isEmpty ||
      RegExp(r'<[a-z][\s\S]*>', caseSensitive: false)
          .hasMatch(normalizedContent)) {
    return normalizedContent;
  }

  return normalizedContent
      .split(RegExp(r'\r?\n'))
      .map((String line) => line.trim())
      .where((String line) => line.isNotEmpty)
      .map((String line) => '<p>${_escapeHtml(line)}</p>')
      .join();
}

String _escapeHtml(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');
