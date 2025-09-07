import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/widgets/app_text.dart';
import '../models/profile_data.dart';

class ProfileItemWidget extends StatelessWidget {

  final ProfileDataModelItem profileDataModelItem;

  const ProfileItemWidget({super.key,
    required this.profileDataModelItem
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: ConstantManager.buttonBorderRadius
      ),
      child: ListTile(
        leading: Image.network(profileDataModelItem.imageUrl),
        title: AppText(profileDataModelItem.title, fontSize: 12.sp),
        subtitle: AppText(profileDataModelItem.value, fontSize: 12.sp, color: AppColors.primary),
      ).paddingAll(10.r),
    );
  }
}
