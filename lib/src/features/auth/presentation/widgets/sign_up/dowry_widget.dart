import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/language/locale_keys.g.dart';
import '../../../../../core/widgets/app_text.dart';
import '../../../../../core/widgets/text_fields/default_text_field.dart';
import '../../../../../core/widgets/validation_helper.dart';
import '../../../models/dowry.dart';

class DowryWidget extends StatefulWidget {
  final void Function(Dowry dowry) onSelect;
  final Dowry? initialValue;
  const DowryWidget({super.key,
    required this.onSelect,
    this.initialValue,
  });

  @override
  State<DowryWidget> createState() => _DowryWidgetState();
}

class _DowryWidgetState extends State<DowryWidget> {
  late TextEditingController _fromController;
  late TextEditingController _toController;

  @override
  void initState() {
    _fromController = TextEditingController(text: widget.initialValue?.from);
    _toController = TextEditingController(text: widget.initialValue?.to);
    super.initState();
  }
  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Dowry get _dowryValue => Dowry(from: _fromController.text, to: _toController.text);

  void onChanged(){
    widget.onSelect.call(_dowryValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(LocaleKeys.dowry, fontWeight: FontWeight.bold, fontSize: 11.sp),
        ValidationHost<Dowry>(
          onSaved: (d){},
          validator: (dowry) {
            final num min = num.tryParse(dowry!.from) ?? 0;
            final num max = num.tryParse(dowry.to) ?? 0;

            if(min >= max){
              return LocaleKeys.theMinDowryCanNotBeGreaterThanMax;
            }

            return null;
          },
          initialValue: widget.initialValue ?? Dowry(from: '0', to: '0'),
          builderWidget: (dowry) => Column(
            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10.w,
                children: [
                  Expanded(
                    child: DefaultTextField(
                      title: LocaleKeys.from,
                      inputType: TextInputType.number,
                      controller: _fromController,
                      onChanged: (v) {
                        dowry.didChange(_dowryValue);
                        onChanged();
                      },
                    ),
                  ),
                  Expanded(
                    child: DefaultTextField(
                      title: LocaleKeys.to,
                      inputType: TextInputType.number,
                      controller: _toController,
                      onChanged: (v) {
                        dowry.didChange(_dowryValue);
                        onChanged();
                      },
                    ),
                  )
                ],
              ),
              if(dowry.hasError)
                AppText(dowry.errorText ?? '', color: Colors.red),
            ],
          ),
        ),

      ],
    );
  }
}
