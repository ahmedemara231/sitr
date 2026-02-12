import 'dart:async';

import 'package:dropinity/helpers/extensions/padding_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/language/locale_keys.g.dart';
import '../../config/res/config_imports.dart';
import '../../features/more/presentation/cubit/delete_child_cubit.dart';
import 'app_text.dart';
import 'buttons/app_loading_button.dart';
import 'buttons/default_button.dart';
import 'default_bottom_sheet.dart';
import 'sheets/delete_sheet.dart';

class ParentChildrenCard extends StatelessWidget {
  final FutureOr<void> Function(BuildContext context) onEditTap;
  final FutureOr<void> Function(BuildContext context) onDeleteTap;
  final String? name;
  final String? url;

  const ParentChildrenCard({super.key,
    required this.onEditTap,
    required this.onDeleteTap,
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
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30.sp,
              backgroundImage: NetworkImage(url ?? ConstantManager.defaultAvatar),
            ),
            title: AppText(name ?? ''),
          ),

          Row(
            spacing: 10.w,
            children: [
              Expanded(
                flex: 2,
                child: AppLoadingButton(
                  borderRadius: ConstantManager.buttonBorderRadiusNumber,
                  textColor: Colors.white,
                  title: LocaleKeys.editData,
                  fontSize: 8.sp,
                  height: 30.h,
                  asyncCall: (context) async => await onEditTap.call(context),
                ),
              ),

              Expanded(
                child: DefaultButton(
                  onTap: () => onDeleteTap.call(context),
                  height: 30.h,
                  fontSize: 8.sp,
                  color: AppColors.pink,
                  borderRadius: BorderRadius.circular(30.r),
                  title: LocaleKeys.delete,
                  textColor: Colors.white,
                ),
              ),
            ],
          ).paddingAll(20.r)
        ],
      ),
    );
  }
}
