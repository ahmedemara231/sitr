import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/helpers/status_builder.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/icon_widget.dart';
import '../../../../../core/widgets/not_contain_data.dart';
import '../../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../cubit/success_partners_cubit/success_partners_cubit.dart';
import '../../models/success_partners_model.dart';

class SuccessPartnersScreen extends StatelessWidget {
  const SuccessPartnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SuccessPartnersCubit()..fetchSuccessPartners(),
      child: AppScaffold(
        isScrollable: true,
        appBarTitle: LocaleKeys.successPartners,
        body: BlocBuilder<SuccessPartnersCubit, AsyncState<List<SuccessPartnersModel>>>(
          builder: (context, state) {
            return StatusBuilder(
              data: state,
              onSuccess: (data,context) {
                return data.isEmpty?
                const NotContainData():
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 163 / 132,
                  ),
                  itemCount: data.length, // total items
                  itemBuilder: (context, index) {
                    return Container(
                      height: 132.h,
                      width: 163.w,
                      padding: EdgeInsets.symmetric(
                          horizontal: 17.w, vertical: 10.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: IconWidget(
                        icon: data[index].image,
                        height: 98.h,
                        width: 142.w,
                      ),
                    );
                  },
                );
              }
            );
          },
        ).paddingAll(16.r),
      ),
    );
  }
}
