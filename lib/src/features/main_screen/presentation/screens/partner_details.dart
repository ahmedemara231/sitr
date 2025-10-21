import 'package:flutter/material.dart';
import '../../../../core/widgets/view_profile_widget.dart';
import '../../../more/presentation/cubit/get_child_profile.dart';
import '../../../more/presentation/cubit/get_profile.dart';
import '../cubits/get_partner_info_cubit.dart';

enum IndividualDetailsType {myChild, profile, opportunity}
class IndividualDetailsScreen extends StatelessWidget {
  final int id;
  final IndividualDetailsType _type;

  const IndividualDetailsScreen.profile({
    super.key,
    required this.id,
  }) : _type = IndividualDetailsType.profile;

  const IndividualDetailsScreen.myChildProfile({
    super.key,
    required this.id,
  }) : _type = IndividualDetailsType.myChild;


  const IndividualDetailsScreen.opportunity({
    super.key,
    required this.id,
  }) : _type = IndividualDetailsType.opportunity;

  @override
  Widget build(BuildContext context) {
    switch(_type){
      case IndividualDetailsType.myChild:
        return ViewProfileWidget<GetChildProfileCubit>.profile(cubit: GetChildProfileCubit(id));

      case IndividualDetailsType.profile:
        return ViewProfileWidget<GetProfileCubit>.profile(cubit: GetProfileCubit());

      default:
        return ViewProfileWidget<GetPartnerInfoCubit>.viewPartner(
          cubit: GetPartnerInfoCubit(id),
          receiverId: id,
        );
    }

  }
}