import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'language';
  static const String _englishCode = 'en';
  static const String _arabicCode = 'ar';

  String currentLanguage = _englishCode;

  LanguageProvider() {
    getLanguage();
  }

  /// Load saved language from SharedPreferences
  void getLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey) ?? _englishCode;

      currentLanguage = savedLanguage == _arabicCode
          ? _arabicCode
          : _englishCode;

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  /// Change app language
  void changeAppLanguage(String newLanguage) async {
    if (currentLanguage == newLanguage) return;

    // Validate language code
    if (newLanguage != _englishCode && newLanguage != _arabicCode) {
      debugPrint('Invalid language code: $newLanguage');
      return;
    }

    currentLanguage = newLanguage;
    saveLanguage(currentLanguage);
    notifyListeners();
  }

  /// Toggle between English and Arabic
  void toggleLanguage() async {
    final newLanguage = currentLanguage == _englishCode
        ? _arabicCode
        : _englishCode;

    changeAppLanguage(newLanguage);
  }

  /// Check if current language is English
  bool get isEnglish => currentLanguage == _englishCode;

  /// Check if current language is Arabic
  bool get isArabic => currentLanguage == _arabicCode;

  /// Save language to SharedPreferences
  void saveLanguage(String lang) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (lang == _arabicCode) {
        prefs.setString(_languageKey, _arabicCode);
      } else {
        prefs.setString(_languageKey, _englishCode);
      }
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
  }
}