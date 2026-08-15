import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../extensions/sized_box_helper.dart';
import '../../../extensions/widget_extension.dart';
import '../models/profile_section_model.dart';
import 'details/profile_detail_section.dart';

class ProfileContent extends StatelessWidget {
  final Widget header;
  final Widget actions;
  final List<ProfileSectionModel> sections;
  final Future<void> Function() onRefresh;

  const ProfileContent({
    super.key,
    required this.header,
    required this.actions,
    required this.sections,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: header),
        SliverPadding(
          padding: EdgeInsetsDirectional.fromSTEB(
            16.w,
            20.h,
            16.w,
            24.h,
          ),
          sliver: SliverList.list(
            children: [
              Column(
                spacing: 20.h,
                children: sections
                    .map(
                      (ProfileSectionModel section) =>
                          ProfileDetailSection(section: section),
                    )
                    .toList(),
              ),
              24.szH,
              actions,
            ],
          ),
        ),
      ],
    ).withPullRefresher(onRefresh: onRefresh);
  }
}
