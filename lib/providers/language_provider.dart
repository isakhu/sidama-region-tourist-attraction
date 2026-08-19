import 'package:flutter/material.dart';

/// Language Provider
/// This manages the current language selection across the entire app
/// Uses ChangeNotifier to notify widgets when the language changes

class LanguageProvider extends ChangeNotifier {
  // Current language locale (default is English)
  Locale _currentLocale = const Locale('en');

  /// Get the current locale
  Locale get currentLocale => _currentLocale;

  /// Get the current language code (e.g., 'en', 'am', 'si')
  String get currentLanguageCode => _currentLocale.languageCode;

  /// Change the app language
  /// This will rebuild all widgets that depend on the language
  void changeLanguage(String languageCode) {
    // Only change if it's a different language
    if (_currentLocale.languageCode != languageCode) {
      _currentLocale = Locale(languageCode);
      
      // Notify all listeners (widgets) that the language has changed
      // This triggers a rebuild of the UI with the new language
      notifyListeners();
    }
  }

  /// Get language name for display
  /// This is useful for showing language options in the UI
  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'am':
        return 'አማርኛ'; // Amharic
      case 'si':
        return 'Sidaamu Afoo'; // Sidaamu Afoo
      default:
        return 'English';
    }
  }

  /// Get all available languages
  /// Returns a list of language codes and their display names
  List<Map<String, String>> get availableLanguages => [
    {'code': 'en', 'name': 'English'},
    {'code': 'am', 'name': 'አማርኛ'},
    {'code': 'si', 'name': 'Sidaamu Afoo'},
  ];
}
