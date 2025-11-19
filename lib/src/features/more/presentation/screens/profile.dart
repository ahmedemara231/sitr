import 'package:flutter/material.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/widgets/view_profile_widget.dart';
import '../cubit/get_profile.dart';
import 'parent_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UserModel.isParent?
    const ParentProfile() :
    ViewProfileWidget.profile(cubit: GetProfileCubit());
  }
}
