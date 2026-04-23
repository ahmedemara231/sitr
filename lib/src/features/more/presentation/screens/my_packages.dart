import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/widgets/not_contain_data.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../packages/models/package.dart';
import '../../../packages/presentation/packages_screen.dart';
import '../../../packages/presentation/widgets/package_widget.dart';
import '../cubit/my_package_cubit.dart';

class MyPackagesScreen extends StatelessWidget {
  const MyPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyPackageCubit()..getMyPackage(),
      child: AppScaffold(
          appBarTitle: LocaleKeys.myPackage,
          body: BlocBuilder<MyPackageCubit, AsyncState<List<Package>>>(
            builder: (context, state) => StatusBuilder(
                data: state,
                onSuccess: (data, context) => data.isEmpty? const NotContainData() :
                PackageWidget(
                    type: ScreenType.renew,
                    package: data.first,
                    onSubscribe: () => context.read<MyPackageCubit>().getMyPackage(),
                ),
            ),
          )
      ),
    );
  }
}
