import 'package:flutter/material.dart';

class ThemeHelper extends ChangeNotifier {
  ThemeHelper._();

  static final ThemeHelper _instance = ThemeHelper._();

  static ThemeHelper get instance => _instance;

  bool _darkMode = false;

  bool get darkMode => _darkMode;

  void changeTheme() {
    _darkMode = !_darkMode;
    notifyListeners();
  }
}
