import 'package:flutter/material.dart';
import '../../../../core/widgets/view_profile_widget.dart';
import '../cubits/get_partner_info_cubit.dart';

class PartnerDetails extends StatelessWidget {
  final int id;
  const PartnerDetails({super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ViewProfileWidget<GetPartnerInfoCubit>.viewPartner(
        cubit: GetPartnerInfoCubit(id)
    );
  }
}