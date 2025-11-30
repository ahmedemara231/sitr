import 'package:easy_chat/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/res/config_imports.dart';
import '../../../../../core/dropinity/helpers/extensions/padding_extension.dart';
import '../../../../../core/helpers/lancher_helper.dart';
import '../../../../../core/navigation/navigator.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/image_widgets/cached_image.dart';
import '../../../../../core/widgets/image_widgets/image_view.dart';
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
        if(!message.sender.isFromMe)
          _MessageBody(message: message),

        Column(
          spacing: 5.h,
          children: [
            InkWell(
              onTap: () => Go.to(
                  message.sender.isFromMe? const ProfileScreen() :
                  ViewProfileWidget<GetPartnerInfoCubit>.viewPartner(
                    cubit: GetPartnerInfoCubit(message.sender.id),
                  )
              ),
              child: CircleAvatar(
                radius: 20.sp,
                backgroundImage: NetworkImage(message.sender.image),
              ),
            ),
            AppText(message.time??'', fontSize: 10.sp, color: Colors.grey),
          ],
        ),

        if(message.sender.isFromMe)
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
          color: message.sender.isFromMe? AppColors.primary : AppColors.whiteGreyColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),

            topLeft: message.sender.isFromMe? Radius.circular(16.r) : Radius.zero,
            topRight: message.sender.isFromMe? Radius.zero: Radius.circular(16.r),
          ),
        ),
        child: message.message.type == 'text'?
        SelectableLinkify(
          text: message.message.body,
          onOpen: (link) => LauncherHelper.launchURL(url: link.url),
          style: TextStyle(
            fontSize: 14.sp,
            color: message.sender.isFromMe?
            Colors.white : Colors.black,
          ),
          linkStyle: TextStyle(
              color: message.sender.isFromMe?
              Colors.white : Colors.blue
          ),
        ).paddingAll(10.r)
            : InkWell(
          onTap: (){
            
            Go.to(ImageView(
              minScale: 5,
                maxScale: 10,
                url: message.message.body
            ));
            // PinchZoom(
            //   child: CachedImage(
            //     url: image,
            //     fit: BoxFit.fill,
            //   ),
            //   maxScale: 2.5,
            //   // onZoomStart: (){print('Start zooming');},
            //   // onZoomEnd: (){print('Stop zooming');},
            // ),
          },
              child: SizedBox.square(
              dimension: 150.sp,
              child: Image.network(message.message.body, fit: BoxFit.fill,)
                      ),
            )
    );
  }
}
