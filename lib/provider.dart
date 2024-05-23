import 'package:flutter/material.dart';

class UIProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  final darkTheme = ThemeData(
      primaryColor: Color(0xff672D6F),
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        background: Color(0xFF1e1e1e),
        secondary: Color(0xFF353535),
        primary: Colors.white,
        tertiary: Colors.grey[700]?.withOpacity(0.3),
      ),
      useMaterial3: true);

  final lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        background: Colors.white,
        secondary: Color(0xFFe9e9e9),
        primary: Colors.black,
        tertiary: Colors.grey[400]?.withOpacity(0.3),
      ),
      useMaterial3: true);

  changeTheme() {
    _isDark = !isDark;
    notifyListeners();
  }

  init() {
    notifyListeners();
  }
}
