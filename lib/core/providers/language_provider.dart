import 'package:flutter/material.dart';
import '../../utils/lang.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  Locale get currentLocale => _currentLocale;

  void changeLanguage(String languageCode) {
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }

  Map<String, String> get texts =>
      lang[_currentLocale.languageCode] ?? lang['en']!;
}
