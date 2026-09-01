import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeViewModel extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeViewModel() {
    _loadTheme();
  }

  // Saved theme મેળવવું
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    _isDarkMode = prefs.getBool('isDarkMode') ?? false;

    notifyListeners();
  }

  // Dark / Light mode બદલવું
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isDarkMode', _isDarkMode);

    notifyListeners();
  }
}
