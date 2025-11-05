import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/dropinity/helpers/extensions/object.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../core/helpers/loading_manager.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/not_contain_data.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/choose_from_options.dart';
import '../../data/models/chat_model.dart';
import '../cubits/get_chats_cubit.dart';
import '../widgets/chat_card.dart';
import 'chat_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with SingleTickerProviderStateMixin{
  final List<String> _chatTitles = [LocaleKeys.myChats, LocaleKeys.previousChats];
  final List<String> _chatTypes = [
    LocaleKeys.completed,
    LocaleKeys.refused,
    LocaleKeys.cancelled,
    LocaleKeys.hanging
  ];

  late String _chatType = _chatTitles.first;

  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: _chatTypes.length, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return AppScaffold(
        appBarTitle: LocaleKeys.chats,
        appBarHeight: _chatType == _chatTitles.last? 220 : 150,
        bottomWidget: PreferredSize(
            preferredSize: Size(double.infinity, 100.h),
            child: Column(
              spacing: 20.h,
              children: [
                ChooseFromOptionsWidget(
                  onSelectOption: (val) =>
                      setState(() => _chatType = val),
                  titles: _chatTitles,
                  fontSize: 16,
                  childPadding: EdgeInsets.symmetric(vertical: 16.h),
                ).paddingAll(10),

                if(_chatType == _chatTitles.last)
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primary,
                    labelStyle: TextStyle(fontFamily: ConstantManager.fontFamily, fontSize: 12.sp, color: AppColors.primary),
                    tabs: List.generate(
                        _chatTypes.length,
                            (i) => Tab(
                              text: _chatTypes[i],
                            ),
                    ),
                ),
              ],
            ),
        ),
      scaffoldBackgroundColor: AppColors.whiteGreyColorProMax,
      body: _chatType == _chatTitles.last ?
      SizedBox(
        height: context.height * 0.5,
        child: TabBarView(
          controller: _tabController,
          children: List.generate(
            _chatTypes.length,
                (i) => _ChatsBody(chatType: ChatType.values[i]),
          ),
        ),
      ) : const _ChatsBody(chatType: ChatType.current)
    );
  }
}

class _ChatsBody extends StatefulWidget {
  final ChatType chatType;
  const _ChatsBody({super.key,
    required this.chatType,
  });

  @override
  State<_ChatsBody> createState() => _ChatsBodyState();
}

class _ChatsBodyState extends State<_ChatsBody> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetChatsCubit>(
      create: (context) => GetChatsCubit()..getChat(widget.chatType),
      child: BlocBuilder<GetChatsCubit, AsyncState<List<ChatModel>>>(
        builder: (context, state) => StatusBuilder(
          data: state,
          onSuccess: (data, context) => data.isNotEmpty? Column(
            spacing: 10.h,
            children: List.generate(
                data.length,
                    (index) => InkWell(
                      onTap: () async => Go.to(ChatScreen(
                          receiverId: data[index].room?.members?.first.id ?? 0,
                          receiverName: data[index].room?.members?.first.name ?? '',
                          fromHome: 1,
                        )),

                      child: ChatCard(
                          url: data[index].room?.members?.first.image ?? '',
                          time: data[index].room?.lastMessageCreatedDt ?? '',
                          partnerName: data[index].room?.members?.first.name ?? '',
                          subTitle: data[index].room!.lastMessageBody.isNotNull?
                          data[index].room!.lastMessageBody!.isImage?
                          LocaleKeys.photo : data[index].room!.lastMessageBody! : '',
                      ),
                    )
            ),
          ) : const NotContainData(),
        ),
      ),
    );
  }
}
