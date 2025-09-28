import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_dev/storage/app_prefs.dart';

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadSavedLocale();
  }

  /// Load the saved locale from storage
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await AppPrefs.instance();
      final savedLocaleCode = prefs.getString(PrefKey.locale);
      
      if (savedLocaleCode != null && savedLocaleCode.isNotEmpty) {
        // Parse the locale code (e.g., "en" or "vi")
        final locale = Locale(savedLocaleCode);
        state = locale;
      }
    } catch (e) {
      // Handle error silently, use default locale
      debugPrint('Error loading saved locale: $e');
    }
  }

  /// Set locale and save it to storage
  Future<void> setLocale(Locale? locale) async {
    state = locale;
    
    try {
      final prefs = await AppPrefs.instance();
      if (locale != null) {
        await prefs.setString(PrefKey.locale, locale.languageCode);
      } else {
        await prefs.remove(PrefKey.locale);
      }
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  /// Clear saved locale
  Future<void> clearLocale() async {
    state = null;
    try {
      final prefs = await AppPrefs.instance();
      await prefs.remove(PrefKey.locale);
    } catch (e) {
      debugPrint('Error clearing locale: $e');
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});


