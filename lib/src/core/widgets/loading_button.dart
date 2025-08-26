import 'package:flutter/material.dart';

import 'buttons/custom_animated_button.dart';
import 'buttons/loading_button.dart';

class LoadingButton extends StatefulWidget {
  final Future<void> Function() asyncCall;
  final String title;
  final Color? textColor;
  final Color? color;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderSide? borderSide;

  const LoadingButton({super.key,
    required this.asyncCall,
    required this.title,
    this.textColor,
    this.color,
    this.borderSide,
    this.borderRadius,
    this.margin,
    this.borderColor,
    this.fontSize,
    this.width,
    this.height,
    this.fontWeight,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {

  late GlobalKey<CustomButtonState> btnKey;

  @override
  void initState() {
     btnKey = GlobalKey<CustomButtonState>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomAnimatedButton(
      title: widget.title,
      onTap: ()async{
        btnKey.currentState!.animateReverse();
        await widget.asyncCall.call();
        btnKey.currentState!.animateForward();
      },
      btnKey: btnKey,
      color: widget.color,
      textColor: widget.textColor,
      borderSide: widget.borderSide,
      borderRadius: widget.borderRadius,
      margin: widget.margin,
      borderColor: widget.borderColor,
      fontSize: widget.fontSize,
      width: widget.width,
      height: widget.height,
      fontWeight: widget.fontWeight,
    );
  }
}
