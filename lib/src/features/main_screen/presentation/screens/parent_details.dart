import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/shared/models/user_models/parent/parent_model.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/chat_button.dart';
import '../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../../core/widgets/parent_children.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../../../../core/widgets/sheets/bloc_success.dart';
import '../../../../core/widgets/sheets/report_cheet.dart';
import '../../data/models/partner_info_model.dart';
import '../cubits/get_partner_info_cubit.dart';
import '../widgets/app_bar_actions.dart';
import '../widgets/partner_info/info_widget.dart';
import 'partner_details.dart';

class ParentDetailsScreen extends StatelessWidget {
  final int id;
  const ParentDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetPartnerInfoCubit(id)..getProfile(),
      child: CenterCardScaffold.withCenteredCard(
        onRefresh: (context) => context.read<GetPartnerInfoCubit>().getProfile(),
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
                  onBlock: (context) => showDefaultBottomSheet(
                    child: BlocManagerSheet(
                        id: id,
                        blocManager: BlocManager.block
                    ),
                  ),
                  onReport: (context) => showDefaultBottomSheet(
                    child: ReportSheet(id: id)
                  ),
              ),
            ],
          ),
          cardTopPadding: 150.h,
          centerCardBody: BlocBuilder<GetPartnerInfoCubit, AsyncState<UserModel>>(
            builder: (context, state) => StatusBuilder(
              data: state,
              onSuccess: (data, context) => Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r)
                ),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: AppText(
                        data.name ?? '',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold
                    ).paddingSymmetric(horizontal: 12.w)
                ),
              ),
            ),
          ),
          body: Column(
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
              ParentChildren(id: id, type: IndividualDetailsType.opportunity),
              BlocBuilder<GetPartnerInfoCubit, AsyncState<UserModel>>(
                builder: (context, state) => StatusBuilder(
                  data: state,
                  onSuccess: (data, context) => ChatButton(user: state.data),
                ),
              ),

            ],
          )
      ),
    );
  }
}
