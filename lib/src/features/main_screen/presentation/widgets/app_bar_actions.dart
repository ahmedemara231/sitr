import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/assets.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/svg_pic.dart';
import '../../../../core/widgets/view_profile_widget.dart';
import 'partner_info/partner_app_bar_icons.dart';

class ProfileAppBarActions extends StatelessWidget {
  final ProfileType _type;
  final FutureOr<void> Function(BuildContext context)? onBlock;
  final FutureOr<void> Function(BuildContext context)? onReport;
  const ProfileAppBarActions({super.key,
    required this.onBlock,
    required this.onReport,
  }) : _type = ProfileType.partnerProfile;

  const ProfileAppBarActions.withBackButtonOnly({super.key})
      : onBlock = null, onReport = null, _type = ProfileType.profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if(_type.isPartnerProfile)
          ...[
            IconButton(
                onPressed: () => onReport?.call(context),
                icon: const PartnerAppBarIcons(
                    icon: Icon(Icons.flag, color: Colors.white)
                )
            ),
            IconButton(
                onPressed: () => onBlock?.call(context),
                icon: PartnerAppBarIcons(
                    icon: const SvgPic(
                        assetName: Assets.svgBlockUser,
                        color: Colors.white
                    ).paddingAll(10)
                )
            ),
          ]
      ],
    ).paddingSymmetric(horizontal: 10.w);
  }
}
