// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../config/language/locale_keys.g.dart';
// import '../../../../core/extensions/sized_box_helper.dart';
// import '../../../../core/widgets/app_text.dart';
// import '../../../../core/widgets/buttons/custom_app_buttons/default_button.dart';
// import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
// import '../widgets/shared/text_field.dart';
// import '../widgets/sign_up/conditions_terms_acceptance.dart';
// import '../widgets/sign_up/dowry_widget.dart';
// import '../widgets/sign_up/drop_down_text_field.dart';
// import '../widgets/sign_up/radio_widget.dart';
// import '../widgets/sign_up/sign_up_upper_widget.dart';
// import 'enter_male_female_child_data.dart';
//
// enum Answer{yes, no}
// enum Nursery{father, mother}
//
// class CompleteProfileScreen extends StatefulWidget {
//   const CompleteProfileScreen({super.key});
//
//   @override
//   State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
// }
//
// class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
//   final formKey = GlobalKey<FormState>();
//
//   late TextEditingController _nameCont;
//   late TextEditingController _statusCont;
//   late TextEditingController _tallCont;
//   late TextEditingController _weightCont;
//   late TextEditingController _currentJobCont;
//   late TextEditingController _briefCont;
//   late TextEditingController _childrenNumberCont;
//   late TextEditingController _thingsCont;
//   late TextEditingController _educationalQualificationCont;
//   late TextEditingController _diseasesCont;
//   late TextEditingController _homeCont;
//   late TextEditingController _parentNameCont;
//   late TextEditingController _parentNumberCont;
//   late TextEditingController _kinshipCont;
//
//
//
//   @override
//   void initState() {
//     _nameCont = TextEditingController();
//     _statusCont = TextEditingController();
//     _tallCont = TextEditingController();
//     _weightCont = TextEditingController();
//     _currentJobCont = TextEditingController();
//     _briefCont = TextEditingController();
//     _childrenNumberCont = TextEditingController();
//     _thingsCont = TextEditingController();
//     _educationalQualificationCont = TextEditingController();
//     _diseasesCont = TextEditingController();
//     _homeCont = TextEditingController();
//     _parentNameCont = TextEditingController();
//     _parentNumberCont = TextEditingController();
//     _kinshipCont = TextEditingController();
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _nameCont.dispose();
//     _statusCont.dispose();
//     _tallCont.dispose();
//     _weightCont.dispose();
//     _currentJobCont.dispose();
//     _briefCont.dispose();
//     _childrenNumberCont.dispose();
//     _thingsCont.dispose();
//     _educationalQualificationCont.dispose();
//     _diseasesCont.dispose();
//     _homeCont.dispose();
//     _parentNameCont.dispose();
//     _parentNumberCont.dispose();
//     _kinshipCont.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const AuthScaffold(
//         upperWidget: SignUpUpperWidget(),
//         body: EnterMaleOrFemaleOrChildDataScreen()
//     );
//   }
// }
