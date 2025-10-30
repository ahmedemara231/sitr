import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';
import '../../../../../core/dropinity/helpers/extensions/padding_extension.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/easy_chat-master/models/chat_message.dart';
import '../../../../../core/widgets/view_profile_widget.dart';
import '../../../../main_screen/presentation/cubits/get_partner_info_cubit.dart';
import '../../../../more/presentation/screens/profile.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessages message;
  
  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10.w,
      children: [
        if(!message.isFromMe)
          _MessageBody(message: message),

        Column(
          spacing: 5.h,
          children: [
            CircleAvatar(
              radius: 20.sp,
              backgroundImage: NetworkImage(message.senderImage ?? ConstantManager.defaultAvatar),
            ),
            AppText(message.time??'', fontSize: 10.sp, color: Colors.grey),
          ],
        ),

        if(message.isFromMe)
          _MessageBody(message: message),
      ],
    );
  }
}

class _MessageBody extends StatelessWidget {
  final ChatMessages message;

  const _MessageBody({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        decoration: BoxDecoration(
          color: message.isFromMe? AppColors.primary : AppColors.whiteGreyColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),

            topLeft: message.isFromMe? Radius.circular(16.r) : Radius.zero,
            topRight: message.isFromMe? Radius.zero: Radius.circular(16.r),
          ),
        ),
        child: message.type == 'text'? AppText(
          message.message,
          fontSize: 14.sp,
          color: message.isFromMe? Colors.white : Colors.black,
        ).paddingAll(10.r) : SizedBox.square(
            dimension: 150.sp,
            child: InkWell(
                onTap: () => Go.to(
                  message.isFromMe? const ProfileScreen() :
                    ViewProfileWidget<GetPartnerInfoCubit>.viewPartner(
                      cubit: GetPartnerInfoCubit(message.id ?? 0),
                    )
                ),
                child: Image.network(message.message, fit: BoxFit.fill,))
        )
    );
  }
}
