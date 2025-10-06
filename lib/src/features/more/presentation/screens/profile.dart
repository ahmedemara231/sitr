import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/res/config_imports.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/padding_extension.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../models/profile_data.dart';
import '../widgets/profile_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ProfileDataModelItem> items = [
    ProfileDataModelItem(title: 'title', imageUrl: 'https://share.google/images/hI0ihMu1THEoFIme6', value: 'value'),
    ProfileDataModelItem(title: 'title', imageUrl: 'https://share.google/images/hI0ihMu1THEoFIme6', value: 'value'),
    ProfileDataModelItem(title: 'title', imageUrl: 'https://share.google/images/hI0ihMu1THEoFIme6', value: 'value'),
    ProfileDataModelItem(title: 'title', imageUrl: 'https://share.google/images/hI0ihMu1THEoFIme6', value: 'value'),
    ProfileDataModelItem(title: 'title', imageUrl: 'https://share.google/images/hI0ihMu1THEoFIme6', value: 'value'),
    ProfileDataModelItem(title: 'title', imageUrl: 'https://share.google/images/hI0ihMu1THEoFIme6', value: 'value'),
    ProfileDataModelItem(title: 'title', imageUrl: 'https://share.google/images/hI0ihMu1THEoFIme6', value: 'value'),
    ProfileDataModelItem(title: 'title', imageUrl: 'https://share.google/images/hI0ihMu1THEoFIme6', value: 'value'),
    ProfileDataModelItem(title: 'title', imageUrl: 'https://share.google/images/hI0ihMu1THEoFIme6', value: 'value'),
    ProfileDataModelItem(title: 'title', imageUrl: 'https://share.google/images/hI0ihMu1THEoFIme6', value: 'value'),
    ProfileDataModelItem(title: 'title', imageUrl: 'https://share.google/images/hI0ihMu1THEoFIme6', value: 'value'),
    ProfileDataModelItem(title: 'title', imageUrl: 'https://share.google/images/hI0ihMu1THEoFIme6', value: 'value'),
    ProfileDataModelItem(title: 'title', imageUrl: 'https://share.google/images/hI0ihMu1THEoFIme6', value: 'value'),
    ProfileDataModelItem(title: 'title', imageUrl: 'https://share.google/images/hI0ihMu1THEoFIme6', value: 'value'),
  ];

  @override
  Widget build(BuildContext context) {
    return CenterCardScaffold.withCenteredCard(
      cardProperties: CardProperties(color: Colors.white),
        upperWidget: SizedBox(
          height: context.height / 5,
          child: Stack(
            children:  [
              // CachedImage(url: ''),
              Image.asset('assets/images/boarding_third.png'),
              const AppBackButton()
            ],
          ),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
           children: List.generate(items.length, (index) => ProfileItemWidget(profileDataModelItem: items[index])),
        ),
        centerCardBody: Column(
          spacing: 5.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText('hello', fontSize: 16.sp, fontWeight: FontWeight.bold),
            const AppText('texttexttext', color: AppColors.primary),
            const AppText('texttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttexttext'),
          ],
        ).paddingAll(12.r)
    );
  }
}
