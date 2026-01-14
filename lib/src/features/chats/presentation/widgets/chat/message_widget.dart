import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/languages.dart';
import '../../../../../config/res/config_imports.dart';
import '../../../../../core/extensions/padding_extension.dart';
import '../../../../../core/helpers/user_type_enum.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/chat_builder/chat_message.dart';
import '../../../../../core/widgets/image_widgets/image_view.dart';

import '../../../../main_screen/presentation/screens/parent_details.dart';
import '../../../../main_screen/presentation/screens/partner_details.dart';
import '../../../../more/presentation/screens/profile.dart';
import '../../../data/chats_data.dart';
import '../../../data/models/chat_model.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessages message;
  
  const ChatMessageWidget({super.key, required this.message});

  Widget get _targetProfile{
    if(message.sender.isFromMe){
      return const ProfileScreen();
    }else{
      final Members member = ChatsData.data!.room!.members!.first;
      if(member.userType?.isParent ?? false){
        return ParentDetailsScreen(id: member.id??0);

      }else{
        return IndividualDetailsScreen.opportunity(id: member.id ?? 0);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10.w,
      children: [
        if(!message.sender.isFromMe && Languages.currentIsArabic)
          ...[
            _MessageBody(message: message),
            Column(
              spacing: 5.h,
              children: [
                InkWell(
                  onTap: () => Go.to(_targetProfile),
                  child: CircleAvatar(
                    radius: 20.sp,
                    backgroundImage: NetworkImage(message.sender.image),
                  ),
                ),
                AppText(message.time??'', fontSize: 10.sp, color: Colors.grey),
              ],
            ),
          ]
        else if(!message.sender.isFromMe && Languages.currentIsEnglish)
          ...[
            Column(
              spacing: 5.h,
              children: [
                InkWell(
                  onTap: () => Go.to(_targetProfile),
                  child: CircleAvatar(
                    radius: 20.sp,
                    backgroundImage: NetworkImage(message.sender.image),
                  ),
                ),
                AppText(message.time??'', fontSize: 10.sp, color: Colors.grey),
              ],
            ),
            _MessageBody(message: message),
          ],


        if(message.sender.isFromMe && Languages.currentIsArabic)
          ...[
            Column(
              spacing: 5.h,
              children: [
                InkWell(
                  onTap: () => Go.to(_targetProfile),
                  child: CircleAvatar(
                    radius: 20.sp,
                    backgroundImage: NetworkImage(message.sender.image),
                  ),
                ),
                AppText(message.time??'', fontSize: 10.sp, color: Colors.grey),
              ],
            ),
            _MessageBody(message: message),
          ]

        else if(message.sender.isFromMe && Languages.currentIsEnglish)
          ...[
            _MessageBody(message: message),
            Column(
              spacing: 5.h,
              children: [
                InkWell(
                  onTap: () => Go.to(_targetProfile),
                  child: CircleAvatar(
                    radius: 20.sp,
                    backgroundImage: NetworkImage(message.sender.image),
                  ),
                ),
                AppText(message.time??'', fontSize: 10.sp, color: Colors.grey),
              ],
            ),
          ]
      ],
    );
  }
}

class _MessageBody extends StatelessWidget {
  final ChatMessages message;

  const _MessageBody({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        decoration: BoxDecoration(
          color: message.sender.isFromMe? AppColors.primary : AppColors.whiteGreyColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),

            topLeft: message.sender.isFromMe? Radius.circular(16.r) : Radius.zero,
            topRight: message.sender.isFromMe? Radius.zero: Radius.circular(16.r),
          ),
        ),
        child: message.message.type == 'text'?
        AppText(
          message.message.body,
          fontSize: 14.sp,
          color: message.sender.isFromMe?
          Colors.white : Colors.black,
        ).paddingAll(10.r) : InkWell(
          onTap: (){
            Go.to(ImageView(
              minScale: 5,
                maxScale: 10,
                url: message.message.body
            ));
          },
          child: SizedBox.square(
              dimension: 150.sp,
              child: Image.network(message.message.body, fit: BoxFit.fill,)
          ),
        )
    ).paddingBottom(10.h);
  }
}
