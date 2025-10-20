import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../../core/widgets/choose_from_options.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBarTitle: LocaleKeys.chats,
        bottomWidget: PreferredSize(
            preferredSize: Size(double.infinity, 100.h),
            child: ChooseFromOptionsWidget(
                onSelectOption: (val) {},
                fontSize: 16,
                titles: [LocaleKeys.myChats, LocaleKeys.previousChats]
            )
        ),
        body: Container()
    );
  }
}
