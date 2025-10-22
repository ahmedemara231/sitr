import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import 'app_text.dart';
import 'buttons/custom_app_buttons/loading_button.dart';

class ParentChildrenCard extends StatelessWidget {
  final FutureOr<void> Function(BuildContext context) onEditTap;
  final String? name;
  final String? url;

  const ParentChildrenCard({super.key,
    required this.onEditTap,
    required this.name,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30.sp,
          backgroundImage: NetworkImage(url ?? ConstantManager.defaultAvatar),
        ),
        title: AppText(name ?? ''),
        trailing: SizedBox(
          width: 100.w,
          height: 40.h,
          child: LoadingButton(
            borderRadius: ConstantManager.buttonBorderRadiusNumber,
            call: (context) async => await onEditTap.call(context),
            idleWidget: AppText(LocaleKeys.editData, fontSize: 12.sp, color: Colors.white),
          ),
        )
      ),
    );
  }
}
