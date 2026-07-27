import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/num.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/shared/models/user_models/individual/individual_user_model.dart';
import '../../../../core/shared/models/user_models/parent/parent_model.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/chat_availability_badge.dart';
import '../../../../core/widgets/chat_button.dart';
import '../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../../core/widgets/parent_children.dart';
import '../../../../core/widgets/scaffolds/center_card_scaffold.dart';
import '../../../../core/widgets/sheets/bloc_success.dart';
import '../../../../core/widgets/sheets/report_sheet.dart';
import '../../../../core/widgets/unavailability_reason_card.dart';
import '../../../chats/data/chat_sheet_manager.dart';
import '../../data/models/partner_info_model.dart';
import '../cubits/get_partner_info_cubit.dart';
import '../widgets/app_bar_actions.dart';
import '../widgets/partner_info/info_widget.dart';
import 'partner_details.dart';

class ParentDetailsScreen extends StatelessWidget {
  final int id;
  const ParentDetailsScreen({super.key, required this.id});

  bool _isNotAvailableToChat(UserModel user) => !user.canChat!.canChat;

  ChatReason? _chatReason(UserModel user) =>
      ChatReason.fromValue(user.canChat!.reason?.value);

  Widget _getAvailabilityStatus(UserModel user) =>
      _isNotAvailableToChat(user)
          ? const ChatAvailabilityBadge.notAvailable()
          : const ChatAvailabilityBadge.available();

  double _calcCenterCardPadding(BuildContext context, UserModel user) {
    final double contentWidth = context.width - 50.w;
    final double nameHeight = _measureTextHeight(
      text: user.name ?? '',
      maxWidth: contentWidth,
      fontSize: 20.sp,
    );
    final double availabilityHeight =
        16.h + _measureTextHeight(
          text: _isNotAvailableToChat(user)
              ? LocaleKeys.notAvailableToChat
              : LocaleKeys.availableToChat,
          maxWidth: contentWidth,
          fontSize: 10.sp,
        );

    double total = 24.r + nameHeight + availabilityHeight + 10.h;

    if (_isNotAvailableToChat(user)) {
      total += 10.h + _unavailabilityCardHeight(contentWidth, user);
    }

    return total;
  }

  double _unavailabilityCardHeight(double contentWidth, UserModel user) {
    final double innerWidth = contentWidth - 32.w;
    final double titleHeight = _measureTextHeight(
      text: LocaleKeys.unavailabilityReason,
      maxWidth: innerWidth,
      fontSize: 12.sp,
    );
    final double bodyHeight = _measureTextHeight(
      text: _chatReason(user).getReason,
      maxWidth: innerWidth,
      fontSize: 10.sp,
    );
    return 28.h + titleHeight + 8.h + bodyHeight;
  }

  double _measureTextHeight({
    required String text,
    required double maxWidth,
    required double fontSize,
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: maxWidth);
    return textPainter.height;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetPartnerInfoCubit(id)..getProfile(),
      child: BlocBuilder<GetPartnerInfoCubit, AsyncState<UserModel>>(
        builder: (context, state) => CenterCardScaffold.withCenteredCard(
          upperWidget: Stack(
            alignment: Alignment.topCenter,
            children: [
              BlocBuilder<GetPartnerInfoCubit, AsyncState<UserModel>>(
                builder: (context, state) => StatusBuilder(
                  data: state,
                  onSuccess: (data, context) => CachedImage(
                      height: 200.h,
                      url: state.data.avatar ?? '', fit: BoxFit.fill
                  ),
                ),
              ),
              Container(
                width: context.width,
                height: 200.h,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black38, Colors.black26])
                ),
              ),

              ProfileAppBarActions(
                  onBlock: (context) => ChatSheetManager.show(
                    child: BlocManagerSheet(
                      id: id,
                      blocManager: BlocManager.block,
                      onPress: () => 2.pop(),
                    ),
                  ),
                  onReport: (context) => ChatSheetManager.show(
                    child: ReportSheet(id: id)
                  ),
              ),
            ],
          ),
          cardTopPadding: 150.h,
          centerCardBody: StatusBuilder(
            data: state,
            onSuccess: (data, context) => SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.h,
                children: [
                  AppText(
                    data.name ?? '',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  _getAvailabilityStatus(data),
                  if (_isNotAvailableToChat(data))
                    UnavailabilityReasonCard(reason: _chatReason(data)),
                ],
              ).paddingAll(12.r),
            ),
          ),
          bodyTopPadding: state.isSuccess
              ? _calcCenterCardPadding(context, state.data)
              : 0,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10.h,
            children: [
              BlocBuilder<GetPartnerInfoCubit, AsyncState<UserModel>>(
                builder: (context, state) => StatusBuilder(
                  data: state,
                  onSuccess: (data, context) => Column(
                    children: [
                      Row(
                        spacing: 10.w,
                        children: [
                          Expanded(child: InfoWidget(partnerInfoModel: PartnerInfoModel(leading: Assets.svgParentIcon, title: LocaleKeys.kinship, subTitle: (data as ParentModel).relation?.value))),
                          Expanded(child: InfoWidget(partnerInfoModel: PartnerInfoModel(leading: Assets.svgParentChildren, title: LocaleKeys.childrenNumber, subTitle: data.numOfChildren.toString())))
                        ],
                      )
                    ],
                  ),
                ),
              ),
              AppText(LocaleKeys.addedChildren, fontSize: 18.sp, fontWeight: FontWeight.bold),
              ParentChildren(id: id, type: IndividualDetailsType.opportunity),
              BlocBuilder<GetPartnerInfoCubit, AsyncState<UserModel>>(
                builder: (context, state) => StatusBuilder(
                  data: state,
                  onSuccess: (data, context) => Center(child: ChatButton(user: state.data)),
                ),
              ),

            ],
          ).withPullRefresher(
            onRefresh: () => context.read<GetPartnerInfoCubit>().getProfile(),
          ),
        ),
      ),
    );
  }
}
