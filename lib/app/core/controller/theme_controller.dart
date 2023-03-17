import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  bool _darkMode = false;

  bool get darkMode => _darkMode;

  void changeTheme() {
    _darkMode = !_darkMode;
    notifyListeners();
  }
}
