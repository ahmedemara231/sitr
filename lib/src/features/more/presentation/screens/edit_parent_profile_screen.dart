import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/base_crud/code/presentation/cubit/base_cubit/async_cubit.dart';
import '../../../../core/helpers/validators.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../core/shared/models/user_models/parent/parent_model.dart';
import '../../../../core/shared/models/user_models/user_model.dart';
import '../../../../core/shared/user_cubit/user_cubit.dart';
import '../../../../core/widgets/app_dropinity.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/custom_messages.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../auth/models/edit_parent_profile_model.dart';
import '../../../auth/models/kinship.dart';
import '../../../auth/presentation/cubits/edit_parent_profile_cubit.dart';
import '../../../auth/presentation/data/auth_data.dart';
import '../../../auth/presentation/widgets/shared/text_field.dart';
import '../../../auth/presentation/widgets/sign_up/image_widget.dart';

class EditParentProfileScreen extends StatefulWidget {
  const EditParentProfileScreen({super.key});

  @override
  State<EditParentProfileScreen> createState() => _EditParentProfileScreenState();
}

class _EditParentProfileScreenState extends State<EditParentProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  // late TextEditingController _identityNumberController;
  late TextEditingController _emailController;
  late TextEditingController _numOfChildrenController;

  File? _selectedAvatar;
  Kinship? _selectedRelation;

  final user = UserCubit.instance.user as ParentModel;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: user.name);
    _ageController = TextEditingController(text: user.age?.toString());
    // _identityNumberController = TextEditingController(text: user.identityNumber);
    _emailController = TextEditingController(text: user.email);
    _numOfChildrenController = TextEditingController(text: user.numOfChildren?.toString());
    _selectedRelation = user.relation;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    // _identityNumberController.dispose();
    _emailController.dispose();
    _numOfChildrenController.dispose();
    super.dispose();
  }

  EditParentProfileModel _buildModel() {
    return EditParentProfileModel(
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()),
      // identityNumber: _identityNumberController.text.trim(),
      email: _emailController.text.trim(),
      relationId: _selectedRelation?.id,
      numOfChildren: int.tryParse(_numOfChildrenController.text.trim()),
      avatar: _selectedAvatar,
    );
  }

  Future<void> _handleSubmit(BuildContext ctx) async {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = ctx.read<EditParentProfileCubit>();

      await cubit.editParentProfile(
        body: _buildModel(),
        onSuccess: (data) {
          UserCubit.instance.updateUser(data.data);
          MessageUtils.showSnackBar(
            LocaleKeys.profileUpdatedSuccessfully,
          );
          Go.back();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditParentProfileCubit(),
      child: AppScaffold(
        appBarTitle: LocaleKeys.editParentProfile,
        body: Form(
          key: _formKey,
          child: Column(
            spacing: 10.h,
            children: [
              // Avatar selector
              SelectImageWidget(
                initialValue: user.avatar,
                  onSelectImage: (image) =>  _selectedAvatar = image
              ),

              // Name field
              SignUpTextField(
                upperTitle: LocaleKeys.name,
                title: LocaleKeys.pleaseEnterName,
                controller: _nameController,
                validator: Validators.validateEmpty,
              ),

              // Age field
              SignUpTextField(
                upperTitle: LocaleKeys.age,
                title: LocaleKeys.pleaseEnterYourAge,
                controller: _ageController,
                inputType: TextInputType.number,
                validator: (v) => Validators.validateAge(v, fieldTitle: LocaleKeys.age, isRequired: true),
              ),

              // Identity number field
              // SignUpTextField(
              //   upperTitle: LocaleKeys.identityNumber,
              //   title: LocaleKeys.pleaseEnterIdentityNumber,
              //   controller: _identityNumberController,
              //   validator: Validators.validateEmpty,
              // ),

              // Email field
              SignUpTextField(
                upperTitle: LocaleKeys.email,
                title: LocaleKeys.pleaseEnterTheEmail,
                controller: _emailController,
                inputType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),

              // Relation dropdown
              AppDropinity<List<Kinship>, Kinship>.withApiRequest(
                title: LocaleKeys.kinship,
                hint: LocaleKeys.selectKinship,
                initialValue: _selectedRelation,
                asyncCall: (context, page) async => await AuthData.getKinships(),
                getLabel: (kinship) => kinship.value,
                onChanged: (kinship) => _selectedRelation = kinship,
                  validator: (e) => Validators.validateEmpty(e?.value)
              ),

              // Number of children field
              SignUpTextField(
                upperTitle: LocaleKeys.childrenNumber,
                title: LocaleKeys.pleaseEnterChildrenNumber,
                controller: _numOfChildrenController,
                inputType: TextInputType.number,
                validator: Validators.validateEmpty,
              ),

              // Submit button
              BlocBuilder<EditParentProfileCubit, AsyncState<UserModel>>(
                builder: (context, state) {
                  return AppLoadingButton(
                    title: LocaleKeys.confirm,
                    asyncCall: (ctx) => _handleSubmit(ctx),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
