import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/assets.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../core/widgets/icon_widget.dart';
import '../../../../core/widgets/svg_pic.dart';
import '../../../auth/imports.dart';
import '../cubit/logout_cubit.dart';

class CustomIconInsideContainer extends StatelessWidget {
  const CustomIconInsideContainer({
    super.key,
    required this.icon,
    this.backgroundColor,
  });

  final String icon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white, shape: BoxShape.circle),
        child: IconWidget(icon: icon));
  }
}
