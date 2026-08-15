import 'package:flutter/material.dart';

import '../../../../../config/res/config_imports.dart';
import '../../models/profile_detail_item_model.dart';
import 'profile_compact_detail_item.dart';
import 'profile_wide_detail_item.dart';

class ProfileDetailRow extends StatelessWidget {
  final List<ProfileDetailItemModel> items;

  const ProfileDetailRow({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.length == 1) {
      return ProfileWideDetailItem(item: items.first);
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: ProfileCompactDetailItem(item: items.first)),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: AppColors.border,
          ),
          Expanded(child: ProfileCompactDetailItem(item: items.last)),
        ],
      ),
    );
  }
}
