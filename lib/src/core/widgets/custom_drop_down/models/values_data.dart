part of '../custom_drop_down.dart';

class ValuesData<Model>{
  final Widget Function(BuildContext context, int i, Model element) itemBuilder;

  ValuesData({
    required this.itemBuilder,
  });
}