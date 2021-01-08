import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  bool _darkTheme;
  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = false;
  }

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    notifyListeners();
  }
}
