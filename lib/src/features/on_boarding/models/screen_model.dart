class ScreenModel{
  final String backgroundImage;
  final String firstText;
  final String secondText;
  final bool isLast;

  ScreenModel({
    required this.backgroundImage,
    required this.firstText,
    required this.secondText,
    this.isLast = false
  });
}