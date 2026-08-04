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
import '../../../../core/widgets/first_validation_error_form.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../auth/models/edit_parent_profile_model.dart';
import '../../../auth/models/kinship.dart';
import '../cubit/edit_parent_profile_cubit.dart';
import '../../../auth/presentation/data/auth_data.dart';
import '../../../auth/presentation/widgets/shared/text_field.dart';
import '../../../auth/presentation/widgets/sign_up/image_widget.dart';

class EditParentProfileScreen extends StatefulWidget {
  const EditParentProfileScreen({super.key});

  @override
  State<EditParentProfileScreen> createState() =>
      _EditParentProfileScreenState();
}

class _EditParentProfileScreenState extends State<EditParentProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirstValidationErrorFieldKeys _validationFieldKeys =
      FirstValidationErrorFieldKeys();

  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  // late TextEditingController _identityNumberController;
  late final TextEditingController _emailController;
  late final TextEditingController _numOfChildrenController;

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
    _numOfChildrenController =
        TextEditingController(text: user.numOfChildren?.toString());
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
    final EditParentProfileCubit cubit = ctx.read<EditParentProfileCubit>();

    await cubit.editParentProfile(
      body: _buildModel(),
      onSuccess: (data) {
        UserCubit.instance.updateUser(data.data);
        MessageUtils.show(
          LocaleKeys.profileUpdatedSuccessfully,
          state: MsgState.success,
        );
        Go.back();
      },
    );
  }

  List<FirstValidationErrorField> _validationFields() {
    return <FirstValidationErrorField>[
      FirstValidationErrorField(
        fieldKey: _validationFieldKeys.get(_ParentProfileField.name),
        title: LocaleKeys.name,
        value: _nameController.text,
        validator: Validators.validateEmpty,
      ),
      FirstValidationErrorField(
        fieldKey: _validationFieldKeys.get(_ParentProfileField.age),
        title: LocaleKeys.age,
        value: _ageController.text,
        validator: (value) => Validators.validateAge(
          value,
          fieldTitle: LocaleKeys.age,
          isRequired: true,
        ),
      ),
      FirstValidationErrorField(
        fieldKey: _validationFieldKeys.get(_ParentProfileField.email),
        title: LocaleKeys.email,
        value: _emailController.text,
        validator: Validators.validateEmail,
      ),
      FirstValidationErrorField(
        fieldKey: _validationFieldKeys.get(_ParentProfileField.relation),
        title: LocaleKeys.kinship,
        value: _selectedRelation?.value,
        validator: Validators.validateEmpty,
      ),
      FirstValidationErrorField(
        fieldKey: _validationFieldKeys.get(
          _ParentProfileField.childrenNumber,
        ),
        title: LocaleKeys.childrenNumber,
        value: _numOfChildrenController.text,
        validator: Validators.validateEmpty,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditParentProfileCubit(),
      child: Builder(
        builder: (context) {
          return AppScaffold(
            appBarTitle: LocaleKeys.editParentProfile,
            body: FirstValidationErrorForm(
              formKey: _formKey,
              validationFields: _validationFields,
              onValid: () => _handleSubmit(context),
              builder: (context, submit) {
                return Column(
                  spacing: 10.h,
                  children: [
                    // Avatar selector
                    SelectImageWidget(
                        initialValue: user.avatar,
                        onSelectImage: (image) => _selectedAvatar = image),

                    // Name field
                    SignUpTextField(
                      key: _validationFieldKeys.get(_ParentProfileField.name),
                      upperTitle: LocaleKeys.name,
                      title: LocaleKeys.pleaseEnterName,
                      controller: _nameController,
                      validator: Validators.validateEmpty,
                    ),

                    // Age field
                    SignUpTextField(
                      key: _validationFieldKeys.get(_ParentProfileField.age),
                      upperTitle: LocaleKeys.age,
                      title: LocaleKeys.pleaseEnterYourAge,
                      controller: _ageController,
                      inputType: TextInputType.number,
                      validator: (v) => Validators.validateAge(v,
                          fieldTitle: LocaleKeys.age, isRequired: true),
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
                      key: _validationFieldKeys.get(_ParentProfileField.email),
                      upperTitle: LocaleKeys.email,
                      title: LocaleKeys.pleaseEnterTheEmail,
                      controller: _emailController,
                      inputType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                    ),

                    // Relation dropdown
                    AppDropinity<List<Kinship>, Kinship>.withApiRequest(
                      key: _validationFieldKeys
                          .get(_ParentProfileField.relation),
                      title: LocaleKeys.kinship,
                      hint: LocaleKeys.selectKinship,
                      initialValue: _selectedRelation,
                      asyncCall: (context, page) async =>
                          await AuthData.getKinships(),
                      getLabel: (kinship) => kinship.value,
                      onChanged: (kinship) => _selectedRelation = kinship,
                      validator: (e) => Validators.validateEmpty(e?.value),
                      cacheKey: 'kinships',
                      cacheToJson: (e) => e.toJson(),
                      cacheFromJson: (json) => Kinship.fromJson(json),
                    ),

                    // Number of children field
                    SignUpTextField(
                      key: _validationFieldKeys.get(
                        _ParentProfileField.childrenNumber,
                      ),
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
                          asyncCall: (context) async => submit(),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

abstract class _ParentProfileField {
  static const String name = 'parent_profile_name';
  static const String age = 'parent_profile_age';
  static const String email = 'parent_profile_email';
  static const String relation = 'parent_profile_relation';
  static const String childrenNumber = 'parent_profile_children_number';
}
