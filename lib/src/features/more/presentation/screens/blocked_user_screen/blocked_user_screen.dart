import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/helpers/status_builder.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/not_contain_data.dart';
import '../../cubit/block_user_cubit/fetch_block_user_cubit.dart';
import '../../models/block_user_model.dart';
import 'widgets/blocked_user_item.dart';

class BlockedUserScreen extends StatefulWidget {
  const BlockedUserScreen({super.key});

  @override
  State<BlockedUserScreen> createState() => _BlockedUserScreenState();
}

class _BlockedUserScreenState extends State<BlockedUserScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FetchBlockUserCubit()..fetchBlockUser(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.whiteScaffoldBackground,
        appBar: customAppBar(appBarTitle: LocaleKeys.blockedCustomers),
        body: BlocBuilder<FetchBlockUserCubit, AsyncState<List<BlockUserModel>>>(
          builder: (context, state) {
            return StatusBuilder(
                data: state,
                onSuccess: (data, context) {
                  return data.isEmpty
                      ? const NotContainData()
                      : ListView.separated(
                          itemBuilder: (context, index) => BlockedUserItem(
                                blockUserModel: data[index],
                                function: (t) {
                                  context
                                      .read<FetchBlockUserCubit>()
                                      .removeItemById(data[index].id ?? 0);
                                },
                              ),
                          separatorBuilder: (context, index) => 15.szH,
                          itemCount: data.length
                  );
                });
          },
        ).paddingAll(16),
      ),
    );
  }
}
