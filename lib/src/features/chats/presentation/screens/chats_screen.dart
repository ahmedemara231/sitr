import 'package:dropinity/helpers/extensions/padding_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/choose_from_options.dart';
import '../widgets/chat_card.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with SingleTickerProviderStateMixin{
  final List<String> _titles = [LocaleKeys.myChats, LocaleKeys.previousChats];
  late String _chatType = _titles.first;
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return AppScaffold(
        appBarTitle: LocaleKeys.chats,
        appBarHeight: _chatType == _titles.last? 220 : 150,
        bottomWidget: PreferredSize(
            preferredSize: Size(double.infinity, 100.h),
            child: Column(
              spacing: 20.h,
              children: [
                ChooseFromOptionsWidget(
                  onSelectOption: (val) {
                    setState(() => _chatType = val);
                    if(val == _titles.first){

                    }else{

                    }
                  },
                  fontSize: 16,
                  titles: _titles,
                  childPadding: EdgeInsets.symmetric(vertical: 16.h),
                ).paddingAll(10),

                if(_chatType == _titles.last)
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primary,
                    labelStyle: TextStyle(fontFamily: ConstantManager.fontFamily, fontSize: 12.sp, color: AppColors.primary),
                    tabs: [
                      Tab(
                        text: LocaleKeys.completed,
                      ),
                      Tab(
                        text: LocaleKeys.refused,
                      ),

                      Tab(
                        text: LocaleKeys.cancelled,
                      ),
                      Tab(
                        text: LocaleKeys.hanging,
                      ),

                    ]
                ),
              ],
            ),
        ),
        scaffoldBackgroundColor: AppColors.whiteGreyColorProMax,
        body: const _ChatsBody()
    );
  }
}

class _ChatsBody extends StatelessWidget {
  const _ChatsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.h,
      children: List.generate(
          10,
              (index) => const ChatCard(
              url: 'url',
              partnerName: 'partnerName',
              subTitle: 'subTitle'
          )
      ),
    );
  }
}
