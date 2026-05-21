import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/extensions/sized_box_helper.dart';
import '../../../../../core/helpers/status_builder.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_messages.dart';
import '../../../../../core/widgets/not_contain_data.dart';
import '../../cubit/contact_us_cubit/contact_us_messages_cubit.dart';
import '../../cubit/contact_us_cubit/send_contact_reply_cubit.dart';
import '../../models/contact_message.dart';
import 'contact_us_screen.dart';
import 'widgets/contact_chat_input_bar.dart';
import 'widgets/contact_message_card.dart';
import 'widgets/contact_reply_preview.dart';
import 'widgets/dot_pattern_background.dart';

class ContactUsChatScreen extends StatefulWidget {
  const ContactUsChatScreen({super.key});

  @override
  State<ContactUsChatScreen> createState() => _ContactUsChatScreenState();
}

class _ContactUsChatScreenState extends State<ContactUsChatScreen> {
  late final TextEditingController _messageController;
  ContactMessage? _replyTarget;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _onReplyTap(ContactMessage message) {
    setState(() => _replyTarget = message);
  }

  void _clearReplyTarget() {
    setState(() => _replyTarget = null);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ContactUsMessagesCubit()..fetchMessages(),
        ),
        BlocProvider(create: (_) => SendContactReplyCubit()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.thirdColor,
        appBar: customAppBar(
          appBarTitle: LocaleKeys.contactUs,
        ),
        body: DotPatternBackground(
          child: BlocBuilder<ContactUsMessagesCubit,
              AsyncState<List<ContactMessage>>>(
            builder: (context, state) {
              return StatusBuilder<List<ContactMessage>>(
                data: state,
                onSuccess: (messages, context) {
                  if (messages.isEmpty) return const _EmptyState();
                  return _ChatThread(
                    messages: messages,
                    selectedReply: _replyTarget,
                    onReplyTap: _onReplyTap,
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ContactReplyPreview(
              target: _replyTarget,
              onCancel: _clearReplyTarget,
            ),
            _InputBar(
              controller: _messageController,
              replyTarget: _replyTarget,
              onReplySent: _clearReplyTarget,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(child: NotContainData()),
          AppLoadingButton(
            title: LocaleKeys.startNewConversation,
            asyncCall: (context) async => Go.to(const ContactUsScreen()),
          ),
          24.szH,
        ],
      ),
    );
  }
}

class _ChatThread extends StatelessWidget {
  const _ChatThread({
    required this.messages,
    required this.selectedReply,
    required this.onReplyTap,
  });

  final List<ContactMessage> messages;
  final ContactMessage? selectedReply;
  final void Function(ContactMessage message) onReplyTap;

  static const double _rightEdge = 0.94;
  static const double _questionWidth = 0.94;
  static const double _adminWidth = 0.84;
  static const double _userReplyWidth = 0.74;

  bool _isQuestion(ContactMessage message) => message.id == message.parentId;

  double _widthFactor(ContactMessage message) {
    if (_isQuestion(message)) return _questionWidth;
    if (message.isSupport) return _adminWidth;
    return _userReplyWidth;
  }

  double _startIndent(ContactMessage message) =>
      _rightEdge - _widthFactor(message);

  String? _badgeFor(ContactMessage message) {
    if (message.isSupport) return LocaleKeys.supportBadge;
    if (_isQuestion(message)) return LocaleKeys.questionBadge;
    return null;
  }

  bool _isSelected(ContactMessage message) {
    final ContactMessage? selected = selectedReply;
    if (selected == null) return false;
    if (message.id == null || selected.id == null) return false;
    return message.id == selected.id && message.sender == selected.sender;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final ContactMessage message = messages[index];
        final bool isLast = index == messages.length - 1;
        final double indentFactor = _startIndent(message);
        final double widthFactor = _widthFactor(message);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: context.width * indentFactor,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: widthFactor,
                  child: ContactMessageCard(
                    message: message,
                    avatarSize: isLast ? 40 : 48,
                    badgeLabel: _badgeFor(message),
                    isSelected: _isSelected(message),
                    onReplyTap: () => onReplyTap(message),
                  ),
                ),
              ),
            ),
            if (!isLast) const _ThreadConnector(),
          ],
        );
      },
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.replyTarget,
    required this.onReplySent,
  });

  final TextEditingController controller;
  final ContactMessage? replyTarget;
  final void Function() onReplySent;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendContactReplyCubit, AsyncState<bool>>(
      builder: (context, sendState) {
        final bool canSend = !sendState.isLoading && replyTarget != null;
        return ContactChatInputBar(
          controller: controller,
          onSendPressed: canSend
              ? () => _handleSend(context, replyTarget!.parentId)
              : _warnNoTarget,
          onCameraPressed: () {},
        ).paddingBottom(MediaQuery.of(context).viewInsets.bottom);
      },
    );
  }

  void _warnNoTarget() {
    MessageUtils.showSnackBar(LocaleKeys.pleaseSelectMessageToReply);
  }

  Future<void> _handleSend(BuildContext context, int parentId) async {
    final String text = controller.text.trim();
    if (text.isEmpty) {
      MessageUtils.showSnackBar(LocaleKeys.fillField);
      return;
    }
    context.hideKeyboard();
    await context.read<SendContactReplyCubit>().sendReply(
          id: parentId,
          message: text,
          onSuccess: () {
            controller.clear();
            onReplySent();
            context.read<ContactUsMessagesCubit>().fetchMessages();
          },
        );
  }
}

/// Minimal L-shaped connector linking consecutive thread bubbles.
class _ThreadConnector extends StatelessWidget {
  const _ThreadConnector();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: context.width * 0.08),
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          width: 48.w,
          height: 32.h,
          decoration: BoxDecoration(
            border: BorderDirectional(
              end: BorderSide(
                color: AppColors.border.withValues(alpha: 0.6),
              ),
              bottom: BorderSide(
                color: AppColors.border.withValues(alpha: 0.6),
              ),
            ),
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(20.r),
            ),
          ),
        ),
      ),
    );
  }
}
