import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UIProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  late SharedPreferences storage;

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
      primaryColor: Color(0xff672D6F),
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
    storage.setBool('isDark', _isDark);
    notifyListeners();
  }

  init() async {
    storage = await SharedPreferences.getInstance();
    _isDark = storage.getBool('isDark') ?? false;
    notifyListeners();
  }
}
