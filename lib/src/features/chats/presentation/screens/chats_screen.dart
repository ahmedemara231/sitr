import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/extensions/widget_extension.dart';
import '../../../../core/helpers/status_builder.dart';
import '../../../../core/shared/route_observer.dart';
import '../../../../core/widgets/not_contain_data.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/choose_from_options.dart';
import '../../data/models/chat_model.dart';
import '../cubits/get_chats_cubit.dart';
import '../widgets/chat_list_tile.dart';

GlobalKey<ChatsScreenState> chatsKey = GlobalKey<ChatsScreenState>();

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => ChatsScreenState();
}

class ChatsScreenState extends State<ChatsScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _chatTitles = [LocaleKeys.myChats, LocaleKeys.previousChats];
  final List<String> _chatTypes = [
    LocaleKeys.completed,
    LocaleKeys.refused,
    LocaleKeys.cancelled,
    LocaleKeys.pending,
  ];

  late String _chatType = _chatTitles.first;

  late final TabController tabController;

  void changeChatsType(String val) {
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
      appBarHeight: _chatType == _chatTitles.last ? 220 : 150,
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
            if (_chatType == _chatTitles.last)
              TabBar(
                controller: tabController,
                indicatorColor: AppColors.primary,
                labelStyle: TextStyle(
                  fontFamily: ConstantManager.fontFamily,
                  fontSize: 12.sp,
                  color: AppColors.primary,
                ),
                tabs: List.generate(
                  _chatTypes.length,
                  (i) => Tab(text: _chatTypes[i]),
                ),
              ),
          ],
        ),
      ),
      scaffoldBackgroundColor: AppColors.whiteGreyColorProMax,
      body: _chatType == _chatTitles.last
          ? SizedBox(
              height: context.height * 0.5,
              child: TabBarView(
                controller: tabController,
                children: List.generate(
                  ChatType.values.length - 1,
                  (i) => _ChatsBody(chatType: ChatType.values[i + 1]),
                ),
              ),
            )
          : const _ChatsBody(chatType: ChatType.current),
    );
  }
}

class _ChatsBody extends StatefulWidget {
  final ChatType chatType;
  const _ChatsBody({required this.chatType});

  @override
  State<_ChatsBody> createState() => _ChatsBodyState();
}

class _ChatsBodyState extends State<_ChatsBody> with RouteAware {
  late final GetChatsCubit _getChatsCubit = GetChatsCubit()..getChat(widget.chatType);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      AppNavigationObserver.instance.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    AppNavigationObserver.instance.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _getChatsCubit.getChat(widget.chatType);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetChatsCubit>.value(
      value: _getChatsCubit,
      child: BlocBuilder<GetChatsCubit, AsyncState<List<ChatModel>>>(
        builder: (context, state) => StatusBuilder(
          data: state,
          onSuccess: (data, context) => data.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      data.length,
                      (index) => ChatListTile(
                        chatModel: data[index],
                        chatType: widget.chatType,
                        index: index,
                      ),
                    ),
                  ),
                ).withPullRefresher(
                  onRefresh: () => context.read<GetChatsCubit>().getChat(widget.chatType),
                )
              : const NotContainData(),
        ),
      ),
    );
  }
}
