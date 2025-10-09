// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../core/helpers/user_type_enum.dart';
// import '../../models/sign_up_body.dart';
// import '../cubits/sign_up_cubit.dart';
//
// class SignUpFactory{
//   static Future<void> execute(BuildContext context, {
//     required SignUpBody signUpBody
//   }) async{
//     late final SignUpBody body;
//     if(signUpBody is MaleAndFemaleSignUp){
//       body = MaleAndFemaleSignUp(
//         age: signUpBody.age,
//         name: signUpBody.name,
//         phone: signUpBody.phone,
//         identityNumber: signUpBody.identityNumber,
//         code: signUpBody.code,
//         image: signUpBody.image,
//         gender: signUpBody.gender,
//       );
//
//     }else if (signUpBody is ParentSignUp){
//       body = ParentSignUp(
//           email: signUpBody.email,
//           kinship: signUpBody.kinship,
//           childrenNumber: signUpBody.childrenNumber,
//           name: signUpBody.name,
//           phone: signUpBody.phone,
//           identityNumber: signUpBody.identityNumber,
//           image: signUpBody.image,
//           gender: signUpBody.gender.toUserType().name,
//           code: signUpBody.code
//       );
//     }
//
//     await context.read<SignUpCubit>().signUp(body);
//   }
// }