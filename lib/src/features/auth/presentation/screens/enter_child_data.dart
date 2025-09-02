import 'package:flutter/material.dart';
import '../../../../core/helpers/user_type_enum.dart';
import '../../../../core/widgets/scaffolds/auth_scaffold.dart';
import '../widgets/shared/choose_gender.dart';
import '../widgets/sign_up/sign_up_upper_widget.dart';

class EnterChildDataScreen extends StatefulWidget {
  const EnterChildDataScreen({super.key});

  @override
  State<EnterChildDataScreen> createState() => _EnterChildDataScreenState();
}

class _EnterChildDataScreenState extends State<EnterChildDataScreen> {
  UserType type = UserType.male;
  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
        upperWidget: const SignUpUpperWidget(),
        body: Column(
          children: [
            ChooseGenderWidget(
              onSelectGender: (selectedGender) => setState(() => type = selectedGender),
              genders: const [
                UserType.male,
                UserType.female,
              ],
            ),
          ],
        )
    );
  }
}
