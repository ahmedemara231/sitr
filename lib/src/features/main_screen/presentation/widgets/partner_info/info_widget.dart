import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/svg_pic.dart';
import '../../../data/models/partner_info_model.dart';

class InfoWidget extends StatelessWidget {
  final PartnerInfoModel partnerInfoModel;
  const InfoWidget({super.key,
    required this.partnerInfoModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: ConstantManager.buttonBorderRadius,
        color: Colors.white,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(5.r),
        leading: _InfoWidgetIcon(assetName: partnerInfoModel.leading??''),
        title: AppText(partnerInfoModel.title??'', color: Colors.black87, fontSize: 10.sp),
        subtitle: AppText(partnerInfoModel.subTitle??'', color: AppColors.primary, fontSize: 10.sp),
      ),
    );
  }
}

class _InfoWidgetIcon extends StatelessWidget {
  final String assetName;
  const _InfoWidgetIcon({required this.assetName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const SvgPic(assetName: Assets.svgGreyBackground),
        SvgPic(assetName: assetName),
      ],
    );
  }
}