import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_dev/storage/app_prefs.dart';
import 'package:flutter_test_dev/theme/app_theme.dart';

/// Theme mode enumeration
enum AppThemeMode {
  light('Light'),
  dark('Dark'),
  universal('Universal'),
  orange('Orange');

  const AppThemeMode(this.displayName);
  final String displayName;
}

/// Theme provider that manages app theme state
class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.universal) {
    _loadSavedTheme();
  }

  /// Load the saved theme from storage
  Future<void> _loadSavedTheme() async {
    try {
      final prefs = await AppPrefs.instance();
      final savedTheme = prefs.getString(PrefKey.theme);
      
      if (savedTheme != null && savedTheme.isNotEmpty) {
        final themeMode = AppThemeMode.values
            .firstWhere((mode) => mode.name == savedTheme, orElse: () => AppThemeMode.universal);
        state = themeMode;
      }
    } catch (e) {
      // Handle error silently, use universal theme
      debugPrint('Error loading saved theme: $e');
    }
  }

  /// Set theme and save it to storage
  Future<void> setTheme(AppThemeMode themeMode) async {
    state = themeMode;
    
    try {
      final prefs = await AppPrefs.instance();
      await prefs.setString(PrefKey.theme, themeMode.name);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  /// Get current theme mode as AppThemeMode
  AppThemeMode get currentAppThemeMode => state;

  /// Clear saved theme (reset to universal)
  Future<void> clearTheme() async {
    state = AppThemeMode.universal;
    try {
      final prefs = await AppPrefs.instance();
      await prefs.remove(PrefKey.theme);
    } catch (e) {
      debugPrint('Error clearing theme: $e');
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});

// Convenience provider for current AppThemeMode
final currentThemeModeProvider = Provider<AppThemeMode>((ref) {
  return ref.watch(themeProvider);
});

// Helper function to get ThemeData based on current theme mode
ThemeData getCurrentThemeData(AppThemeMode themeMode) {
  switch (themeMode) {
    case AppThemeMode.light:
      return AppTheme.lightTheme;
    case AppThemeMode.dark:
      return AppTheme.darkTheme;
    case AppThemeMode.universal:
      return AppTheme.universalTheme;
    case AppThemeMode.orange:
      return AppTheme.orangeTheme;
  }
}
