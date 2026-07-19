import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the light/dark preference and persists it between launches.
class ThemeProvider extends ChangeNotifier {
  static const String _prefsKey = 'theme_mode';

  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    if (stored == 'dark') {
      _mode = ThemeMode.dark;
    } else if (stored == 'light') {
      _mode = ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> toggle(BuildContext context) async {
    final isCurrentlyDark = _mode == ThemeMode.dark ||
        (_mode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    _mode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefsKey,
      _mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}
