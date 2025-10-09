import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadTheme();
  }

  /// Toggle between light and dark mode
  void toggleTheme(bool isOn) async {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isOn);

    // ✅ Update status bar style
    _updateStatusBar(isOn);

    notifyListeners();
  }

  /// Load saved theme preference from SharedPreferences
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? true;

    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    // ✅ Update status bar when loading saved theme
    _updateStatusBar(isDark);

    notifyListeners();
  }

  /// Updates status bar color and icon brightness based on theme
  void _updateStatusBar(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF5F5F5), // ✅ off-white for visibility
        statusBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark, // ✅ Android
        statusBarBrightness: isDark
            ? Brightness.dark
            : Brightness.light, // ✅ iOS
      ),
    );
  }
}
