import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeotechController extends ChangeNotifier {
  static const _themeKey = 'lithica_geotech_theme_v1';
  static const _langKey = 'lithica_geotech_lang_v1';
  static const _scaleKey = 'lithica_geotech_scale_v1';
  static const _expertModeKey = 'lithica_geotech_expert_mode_v1';

  ThemeMode themeMode = ThemeMode.system;
  String languageCode = 'es';
  double guiScale = 1.0;
  bool expertMode = false;

  GeotechController() {
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      final savedLang = prefs.getString(_langKey);
      final savedScale = prefs.getDouble(_scaleKey);
      final savedExpertMode = prefs.getBool(_expertModeKey);

      if (savedTheme == 'light') {
        themeMode = ThemeMode.light;
      } else if (savedTheme == 'dark') {
        themeMode = ThemeMode.dark;
      } else {
        themeMode = ThemeMode.system;
      }

      if (savedLang == 'es' || savedLang == 'en') {
        languageCode = savedLang!;
      }

      if (savedScale != null && savedScale >= 0.8 && savedScale <= 1.4) {
        guiScale = (savedScale * 10).round() / 10;
      }
      expertMode = savedExpertMode ?? false;

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading GeotechController preferences: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (themeMode == mode) return;
    themeMode = mode;
    notifyListeners();
    _savePreference(_themeKey, mode.name);
  }

  Future<void> setLanguage(String lang) async {
    if (languageCode == lang) return;
    languageCode = lang;
    notifyListeners();
    _savePreference(_langKey, lang);
  }

  Future<void> setGuiScale(double scale) async {
    final normalized = (scale.clamp(0.8, 1.4) * 10).round() / 10;
    if (guiScale == normalized) return;
    guiScale = normalized;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_scaleKey, normalized);
    } catch (e) {
      debugPrint('Error saving gui scale: $e');
    }
  }

  Future<void> setExpertMode(bool enabled) async {
    if (expertMode == enabled) return;
    expertMode = enabled;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_expertModeKey, enabled);
    } catch (e) {
      debugPrint('Error saving expert mode: $e');
    }
  }

  Future<void> _savePreference(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (e) {
      debugPrint('Error saving preference $key: $e');
    }
  }
}
