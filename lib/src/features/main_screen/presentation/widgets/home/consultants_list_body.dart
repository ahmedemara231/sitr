import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/widgets/not_contain_data.dart';
import '../../../data/models/home_model.dart';
import 'mariage_consultant.dart';

class ConsultantsListBody extends StatelessWidget {
  final List<MarriageConsultants>? consultants;

  const ConsultantsListBody({
    super.key,
    required this.consultants,
  });

  @override
  Widget build(BuildContext context) {
    return consultants?.isEmpty ?? true? const NotContainData() : Column(
      spacing: 10.h,
      children: List.generate(
        consultants?.length ?? 0,
        (i) {
          final consultant = consultants?[i];
          return MarriageConsultantCard(
            name: consultant?.name ?? '',
            phone: consultant?.phone ?? '',
            parentImage: consultant?.image ?? '',
            description: consultant?.description ?? '',
          );
        },
      ),
    );
  }
}
