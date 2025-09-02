import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagify/helpers/data_and_pagination_data.dart';
import 'package:pagify/helpers/errors.dart';
import 'package:pagify/pagify.dart';
import '../../../config/language/locale_keys.g.dart';
import '../../../core/widgets/app_pagify.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/scaffolds/app_scaffold.dart';
import '../models/package.dart';
import 'cubits/get_packages.dart';
import 'widgets/package_widget.dart';

enum ScreenType{view, subscribe}

class PackagesScreen extends StatelessWidget {
  final ScreenType type;

  const PackagesScreen.view({super.key}) : type = ScreenType.view;
  const PackagesScreen.subscribe({super.key}) : type = ScreenType.subscribe;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetPackagesCubit(),
      child: AppScaffold(
          appBarTitle: LocaleKeys.packages,
          body: Column(
            children: [
              AppText(LocaleKeys.inOrderToRegisterOtherDataYouMustSubscribeToOneOfTheAvailablePackages, textAlign: TextAlign.center,),

              AppPagify<Package>(
                  asyncCall: (ctx, page) async => await ctx.read<GetPackagesCubit>().getPackages(),
                  itemBuilder: (ctx, data, index, element) => PackageWidget(type: type),
                  pagifyController: PagifyController()
              )
            ],
          )
      ),
    );
  }
}
