import 'package:flutter/material.dart';

class LanguageNotifier extends ChangeNotifier {
  final String key = "language";
  Locale _currentLocale;
  Locale get currentLocale => _currentLocale;

  LanguageNotifier(BuildContext context) {
    _currentLocale = Locale('bs');
  }

  void changeLanguage(Locale newLanguage) {
    _currentLocale = newLanguage;
    notifyListeners();
  }
}
