import 'package:flutter/material.dart';

import '../../../../core/helpers/gender_enum.dart';
import '../../../../core/widgets/buttons/default_button.dart';

class ChooseGenderWidget extends StatelessWidget {
  final Function(Gender selectedGender) onSelectGender;

  const ChooseGenderWidget({super.key,
    required this.onSelectGender,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
          Gender.values.length,
          (index) => Expanded(
            child: DefaultButton(
              title: Gender.values[index].name,
              onTap: () {
                onSelectGender(Gender.values[index]);
              },
            ),
          )
      ),
    );
  }
}
