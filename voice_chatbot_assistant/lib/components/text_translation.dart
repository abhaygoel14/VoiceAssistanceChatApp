// translation.dart
import 'package:translator/translator.dart';

class TranslationService {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translateText(String text, String toLanguageCode) async {
    final translated = await _translator.translate(text, to: toLanguageCode);
    return translated.text;
  }
}
