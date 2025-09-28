import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_dev/l10n/generated/app_localizations.dart';
import 'package:flutter_test_dev/providers/locale_provider.dart';
import 'package:flutter_test_dev/providers/theme_provider.dart';
import 'package:flutter_test_dev/router/app_route_path.dart';

/// A reusable settings button widget that opens settings modal
class SettingsButton extends ConsumerWidget {
  final BuildContext? currentContext;
  /// Optional custom icon for the settings button
  final IconData? icon;
  
  /// Optional custom tooltip for the settings button
  final String? tooltip;
  
  /// Whether to show language settings in the modal
  final bool showLanguageSettings;
  
  /// Whether to show theme settings in the modal
  final bool showThemeSettings;
  
  /// Custom title for the settings modal
  final String? modalTitle;

  /// Static variable to track if a settings modal is currently being shown
  static bool _isModalShowing = false;

  const SettingsButton({
    super.key,
    this.icon,
    this.tooltip,
    this.showLanguageSettings = true,
    this.showThemeSettings = true,
    this.modalTitle,
    this.currentContext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(icon ?? Icons.settings),
      // tooltip: tooltip ?? 'Settings',
      onPressed: () => _showSettingsModal(context, ref),
    );
  }

  /// Show the settings modal with theme and language options
  void _showSettingsModal(BuildContext context, WidgetRef ref) {
    // Prevent showing multiple modals simultaneously
    if (_isModalShowing) return;
    
    _isModalShowing = true;
    
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: currentContext ?? ref.context,
      builder: (ctx) => SettingsModal(
        showLanguageSettings: showLanguageSettings,
        showThemeSettings: showThemeSettings,
        title: modalTitle,
      ),
    ).whenComplete(() {
      // Reset the flag when the modal is dismissed
      _isModalShowing = false;
    });
  }
}

/// Settings modal content widget
class SettingsModal extends ConsumerWidget {
  /// Whether to show language settings
  final bool showLanguageSettings;
  
  /// Whether to show theme settings
  final bool showThemeSettings;
  
  /// Custom title for the modal
  final String? title;

  const SettingsModal({
    super.key,
    this.showLanguageSettings = true,
    this.showThemeSettings = true,
    this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeProvider);
    final currentTheme = ref.read(themeProvider);
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? 'Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          
          // Language Section
          if (showLanguageSettings) ...[
            _buildLanguageSection(context, ref, currentLocale, loc),
            const SizedBox(height: 20),
          ],
          
          // Theme Section
          if (showThemeSettings) ...[
            _buildThemeSection(context, ref, currentTheme, loc),
            const SizedBox(height: 20),
          ],
          
          // Done Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => AppRoutePath.back(context),
              child: Text(loc.settingsDone),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the language selection section
  Widget _buildLanguageSection(
    BuildContext context,
    WidgetRef ref,
    Locale? currentLocale,
    AppLocalizations loc,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.language,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        RadioListTile<Locale>(
          value: const Locale('en'),
          groupValue: currentLocale ?? const Locale('en'),
          title: Text(loc.languageEnglish),
          onChanged: (val) async {
            await ref.read(localeProvider.notifier).setLocale(val);
          },
        ),
        RadioListTile<Locale>(
          value: const Locale('vi'),
          groupValue: currentLocale ?? const Locale('en'),
          title: Text(loc.languageVietnamese),
          onChanged: (val) async {
            await ref.read(localeProvider.notifier).setLocale(val);
          },
        ),
      ],
    );
  }

  /// Build the theme selection section
  Widget _buildThemeSection(
    BuildContext context,
    WidgetRef ref,
    AppThemeMode currentTheme,
    AppLocalizations loc,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.theme,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        RadioListTile<AppThemeMode>(
          value: AppThemeMode.light,
          groupValue: currentTheme,
          title: Text(loc.themeLight),
          secondary: const Icon(Icons.light_mode),
          onChanged: (val) async {
            await ref.read(themeProvider.notifier).setTheme(val!);
          },
        ),
        RadioListTile<AppThemeMode>(
          value: AppThemeMode.dark,
          groupValue: currentTheme,
          title: Text(loc.themeDark),
          secondary: const Icon(Icons.dark_mode),
          onChanged: (val) async {
            await ref.read(themeProvider.notifier).setTheme(val!);
          },
        ),
        RadioListTile<AppThemeMode>(
          value: AppThemeMode.universal,
          groupValue: currentTheme,
          title: Text(loc.themeUniversal),
          secondary: const Icon(Icons.settings_system_daydream),
          onChanged: (val) async {
            await ref.read(themeProvider.notifier).setTheme(val!);
          },
        ),
        RadioListTile<AppThemeMode>(
          value: AppThemeMode.orange,
          groupValue: currentTheme,
          title: Text(loc.themeOrange),
          secondary: const Icon(Icons.wb_sunny),
          onChanged: (val) async {
            await ref.read(themeProvider.notifier).setTheme(val!);
          },
        ),
      ],
    );
  }
}
