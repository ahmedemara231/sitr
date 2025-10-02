import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';

class DowryWidget extends StatefulWidget {
  final void Function(String from, String to) onSelect;
  const DowryWidget({super.key,
    required this.onSelect,
  });

  @override
  State<DowryWidget> createState() => _DowryWidgetState();
}

class _DowryWidgetState extends State<DowryWidget> {
  late TextEditingController _fromController;
  late TextEditingController _toController;

  @override
  void initState() {
    _fromController = TextEditingController();
    _toController = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void onChanged(){
    widget.onSelect.call(_fromController.text, _toController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(LocaleKeys.dowry, fontWeight: FontWeight.bold, fontSize: 11.sp),
        Row(
          spacing: 10.w,
          children: [
            Expanded(
              child: DefaultTextField(
                title: LocaleKeys.from,
                inputType: TextInputType.number,
                controller: _fromController,
                onChanged: (v) => onChanged(),
              ),
            ),
            Expanded(
              child: DefaultTextField(
                title: LocaleKeys.to,
                inputType: TextInputType.number,
                controller: _toController,
                onChanged: (v) => onChanged(),
              ),
            )
          ],
        ),
      ],
    );
  }
}
