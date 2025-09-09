import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/language/locale_keys.g.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/widgets/buttons/app_loading_button.dart';
import '../../../../core/widgets/scaffolds/app_scaffold.dart';
import '../../../auth/presentation/widgets/shared/text_field.dart';
import '../../../auth/presentation/widgets/sign_up/drop_down_text_field.dart';
import '../../../auth/presentation/widgets/sign_up/shared_form_fields.dart';
import '../widgets/edit_profile_image_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  late UserType type;
  late TextEditingController _nameCont;
  late TextEditingController _phoneCont;
  late TextEditingController _identifyNumberCont;
  late TextEditingController _ageCont;
  late TextEditingController _liveAfterMarryCont;
  late TextEditingController _parentNameCont;
  late TextEditingController _parentNumberCont;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    type = UserTypeHelper.currentGender;
    _nameCont = TextEditingController();
    _phoneCont = TextEditingController();
    _identifyNumberCont = TextEditingController();
    _ageCont = TextEditingController();
    _liveAfterMarryCont = TextEditingController();
    _parentNameCont = TextEditingController();
    _parentNumberCont = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _phoneCont.dispose();
    _identifyNumberCont.dispose();
    _ageCont.dispose();
    _liveAfterMarryCont.dispose();
    _parentNameCont.dispose();
    _parentNumberCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        appBarTitle: LocaleKeys.profile,
        body: Form(
          key: _formKey,
          child: Column(
            spacing: 10.h,
            children: [
              EditProfileImageWidget(onSelectImage: (image){}),

              if(type.isFemale)
                SharedFormFields(
                  onFinished: (data){},
                  onInitData: (List<Widget> children) => children..insertAll(18, [
                    SignUpTextField(
                      upperTitle: LocaleKeys.whereDoYouAcceptToLiveAfterMarriage,
                      title: LocaleKeys.pleaseEnterTheNumber,
                      controller: _liveAfterMarryCont,
                      // validator: Validators.validateEmpty,
                    ),
                  ])..insertAll(23, [
                    DropDownTextField(title: LocaleKeys.areYouWaringHijab, onChanged: (val){}),
                    DropDownTextField(title: LocaleKeys.degreeOfCommitment, onChanged: (val){}),
                    SignUpTextField(
                      upperTitle: LocaleKeys.parentName,
                      title: LocaleKeys.pleaseEnterName,
                      controller: _parentNameCont,
                      // validator: Validators.validateEmpty,
                    ),
                    SignUpTextField(
                      upperTitle: LocaleKeys.parentNumber,
                      title: LocaleKeys.pleaseEnterTheNumber,
                      controller: _parentNumberCont,
                      // validator: Validators.validateEmpty,
                    ),
                  ]),
                )
              else
                SharedFormFields(
                  onFinished: (data){},
                  onInitData: (List<Widget> children) => children
                    ..insertAll(2, [
                      SignUpTextField(
                        upperTitle: LocaleKeys.age,
                        title: LocaleKeys.pleaseEnterYourAge,
                        controller: _ageCont,
                        // validator: Validators.validateEmpty,
                      ),
                    ]),
                ),

              AppLoadingButton(
                asyncCall: (ctx) async{
                  if(_formKey.currentState!.validate()){

                  }
                },
                title: LocaleKeys.saveChanges,
              ),
            ],
          ),
        )
    );
  }
}
