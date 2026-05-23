import 'package:safe_text/safe_text.dart';

class SafeTextHelper{
  static Future<void> init()async{
    await SafeTextFilter.init(languages: [Language.english, Language.arabic]);
  }
}