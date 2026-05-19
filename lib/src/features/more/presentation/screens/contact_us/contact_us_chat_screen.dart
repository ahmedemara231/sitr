import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../models/contact_message.dart';
import 'widgets/contact_chat_input_bar.dart';
import 'widgets/contact_message_card.dart';
import 'widgets/dot_pattern_background.dart';

class ContactUsChatScreen extends StatefulWidget {
  const ContactUsChatScreen({super.key});

  @override
  State<ContactUsChatScreen> createState() => _ContactUsChatScreenState();
}

class _ContactUsChatScreenState extends State<ContactUsChatScreen> {
  late final TextEditingController _messageController;

  // Conversation thread. Replace with cubit-backed data once the API is wired.
  static const List<ContactMessage> _messages = [
    ContactMessage(
      sender: ContactSender.user,
      authorName: 'أحمد محمد',
      message: 'السلام عليكم، لدي استفسار بخصوص تفعيل باقتي.',
      time: 'منذ ساعتين',
      avatarUrl: '',
    ),
    ContactMessage(
      sender: ContactSender.support,
      authorName: 'فريق الدعم',
      message: 'وعليكم السلام، أهلاً بك. هل يمكنك تزويدنا برقم الهاتف المسجل؟',
      time: 'منذ ساعة',
    ),
    ContactMessage(
      sender: ContactSender.user,
      authorName: 'أحمد محمد',
      message: 'أهلاً، الرقم هو 05xxxxxxxx',
      time: 'منذ 30 دقيقة',
      avatarUrl: '',
      highlighted: true,
    ),
  ];

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

  // widthFactor / start-indent per depth — recreates the cascading thread.
  double _widthFactor(int index) => 0.94 - (index * 0.06);

  double _startIndent(int index) => index * 0.06;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.thirdColor,
      appBar: customAppBar(appBarTitle: LocaleKeys.contactUs),
      body: DotPatternBackground(
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            final ContactMessage message = _messages[index];
            final bool isLast = index == _messages.length - 1;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: context.width * _startIndent(index),
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FractionallySizedBox(
                      alignment: AlignmentDirectional.centerStart,
                      widthFactor: _widthFactor(index),
                      child: ContactMessageCard(
                        message: message,
                        avatarSize: isLast ? 40 : 48,
                        badgeLabel: _badgeFor(message, index),
                      ),
                    ),
                  ),
                ),
                if (!isLast) const _ThreadConnector(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: ContactChatInputBar(
        controller: _messageController,
        onSendPressed: () {},
        onCameraPressed: () {},
      ),
    );
  }

  String? _badgeFor(ContactMessage message, int index) {
    if (message.isSupport) return LocaleKeys.supportBadge;
    if (index == 0) return LocaleKeys.questionBadge;
    return null;
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
