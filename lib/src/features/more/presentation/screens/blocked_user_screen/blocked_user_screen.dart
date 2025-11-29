import 'package:flutter/material.dart';
import 'package:pagify/pagify.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/app_pagify.dart';
import '../../../../../core/widgets/default_bottom_sheet.dart';
import '../../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../../core/widgets/sheets/bloc_success.dart';
import '../../../data/more_data.dart';
import '../../models/block_user_model.dart';
import 'widgets/blocked_user_item.dart';

class BlockedUserScreen extends StatefulWidget {
  const BlockedUserScreen({super.key});

  @override
  State<BlockedUserScreen> createState() => _BlockedUserScreenState();
}

class _BlockedUserScreenState extends State<BlockedUserScreen> {
  late final PagifyController<BlockUserModel> _controller;

  @override
  void initState() {
    _controller = PagifyController<BlockUserModel>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isScrollable: false,
        appBarTitle: LocaleKeys.blockedCustomers,
        body: AppPagify<BlockUserModel>(
            asyncCall: (context, page) => MoreData.getBlockedUsers(page),
            itemBuilder: (context, data, index, element) => BlockedUserItem(
              blockUserModel: element,
              onDelete: (ctx)  {
                showDefaultBottomSheet(
                    child: BlocManagerSheet(
                      id: element.id ?? 0,
                      blocManager: BlocManager.unblock,
                      onPress: () {
                        _controller.removeAt(index);
                        Go.back();
                      }
                    )
                );
               }),
            pagifyController: _controller
        )
    );
  }
}
