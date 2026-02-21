import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagify/pagify.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/object.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/widgets/not_contain_data.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/choose_from_options.dart';
import '../../data/models/chat_model.dart';
import '../../data/models/request_model.dart';
import '../cubits/get_chats_cubit.dart';
import '../imports.dart';
import '../widgets/chat/chat_view.dart';
import '../widgets/chat/upper_view.dart';
import '../widgets/chat_card.dart';

GlobalKey<ChatsScreenState> chatsKey = GlobalKey<ChatsScreenState>();

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen>
    with SingleTickerProviderStateMixin{
  final List<String> _chatTitles = [LocaleKeys.myChats, LocaleKeys.previousChats];
  final List<String> _chatTypes = [
    LocaleKeys.completed,
    LocaleKeys.refused,
    LocaleKeys.cancelled,
    LocaleKeys.pending
  ];

  late String _chatType = _chatTitles.first;

  late final TabController tabController;

  void changeChatsType(String val){
    setState(() => _chatType = val);
  }

  @override
  void initState() {
    tabController = TabController(length: _chatTypes.length, vsync: this);
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
                  onSelectOption: (val) => changeChatsType(val),
                  titles: _chatTitles,
                  fontSize: 16,
                  childPadding: EdgeInsets.symmetric(vertical: 16.h),
                ).paddingAll(10),

                if(_chatType == _chatTitles.last)
                  TabBar(
                    controller: tabController,
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
          controller: tabController,
          children: List.generate(
            ChatType.values.length - 1,
                (i) => _ChatsBody(chatType: ChatType.values[i + 1]),
          ),
        ),
      ) : const _ChatsBody(chatType: ChatType.current)
    );
  }
}

class _ChatsBody extends StatefulWidget {
  final ChatType chatType;
  const _ChatsBody({required this.chatType});

  @override
  State<_ChatsBody> createState() => _ChatsBodyState();
}

class _ChatsBodyState extends State<_ChatsBody> {

  String get _getLabel{
    switch(widget.chatType){
      case ChatType.completed:
        return LocaleKeys.completed;

        case ChatType.rejected:
          return LocaleKeys.refused;

        case ChatType.cancelled:
          return LocaleKeys.cancelled;

        case ChatType.pending:
          return LocaleKeys.pending;

        default:
          return 'not type';
    }
  }

  Color get _getLabelBackgroundColor{
    switch(widget.chatType){
      case ChatType.completed:
      case ChatType.pending:
        return Colors.green;

      case ChatType.rejected:
      case ChatType.cancelled:
        return Colors.red;

      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetChatsCubit>(
      create: (context) => GetChatsCubit()..getChat(widget.chatType),
      child: BlocBuilder<GetChatsCubit, AsyncState<List<ChatModel>>>(
        builder: (context, state) => StatusBuilder(
          data: state,
          onSuccess: (data, context) => data.isNotEmpty? SingleChildScrollView(
            child: Column(
              children: List.generate(
                  data.length,
                      (index) => InkWell(
                        onTap: (){
                          late Widget targetScreen;
                          final requestModel = RequestModel(
                              receiverId: '${data[index].room?.members?.first.id}',
                              fromHome: 0.toString()
                          );

                          if(widget.chatType == ChatType.current){
                            targetScreen = ChatScreen(
                              receiverName: data[index].room?.members?.first.name ?? '',
                              requestModel: requestModel
                            );

                          }else{
                            targetScreen = AppScaffold(
                                appBarTitle: LocaleKeys.chat,
                                body: Column(
                                  spacing: 10.h,
                                  children: [
                                    ChatUpperWidget.withLabel(
                                        requestId: requestModel.receiverId,
                                        label: _getLabel,
                                        labelBackgroundColor: _getLabelBackgroundColor
                                    ),
                                    SizedBox(
                                      height: context.height - 170,
                                      child: ChatView(
                                          requestModel: requestModel,
                                          chatController: PagifyController()
                                      ),
                                    ),
                                  ],
                                )
                            );
                          }

                          context.read<GetChatsCubit>().resetUnreadMessagesCount(index);
                          Go.to(targetScreen);
                        },
                        child: ChatCard(
                          url: data[index].room?.members?.first.image ?? '',
                          time: data[index].room?.lastMessageCreatedDt ?? '',
                          partnerName: data[index].room?.members?.first.name ?? '',
                          subTitle: data[index].room!.lastMessageBody.isNotNull?
                          data[index].room!.lastMessageBody!.isImage?
                          LocaleKeys.photo : data[index].room!.lastMessageBody! : '',
                          unreadMsgs: data[index].room!.unreadMsgs ?? 1,
                        ).paddingBottom(10.h),
                      )
              ),
            )
          ).withPullRefresher(
            onRefresh: () => context.read<GetChatsCubit>().getChat(widget.chatType),
          ) : const NotContainData(),
        ))
    );
  }
}
