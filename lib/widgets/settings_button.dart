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
class SettingsModal extends ConsumerStatefulWidget {
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
  ConsumerState<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends ConsumerState<SettingsModal> {
  Locale? _selectedLocale;
  AppThemeMode? _selectedTheme;

  @override
  void initState() {
    super.initState();
    // Initialize with current values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedLocale = ref.read(localeProvider);
        _selectedTheme = ref.read(themeProvider);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title ?? 'Settings',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          
          // Language Section
          if (widget.showLanguageSettings) ...[
            _buildLanguageSection(context, ref, loc),
            const SizedBox(height: 20),
          ],
          
          // Theme Section
          if (widget.showThemeSettings) ...[
            _buildThemeSection(context, ref, loc),
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
        _buildLanguageOption(
          context,
          ref,
          const Locale('en'),
          loc.languageEnglish,
          _selectedLocale ?? const Locale('en'),
        ),
        _buildLanguageOption(
          context,
          ref,
          const Locale('vi'),
          loc.languageVietnamese,
          _selectedLocale ?? const Locale('en'),
        ),
      ],
    );
  }

  /// Build individual language option
  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    Locale locale,
    String title,
    Locale selectedLocale,
  ) {
    final isSelected = locale == selectedLocale;
    
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLocale = locale;
          });
          ref.read(localeProvider.notifier).setLocale(locale);
        },
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          child: isSelected
            ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            : null,
        ),
      ),
      title: Text(title),
      onTap: () {
        setState(() {
          _selectedLocale = locale;
        });
        ref.read(localeProvider.notifier).setLocale(locale);
      },
    );
  }

  /// Build the theme selection section
  Widget _buildThemeSection(
    BuildContext context,
    WidgetRef ref,
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
        _buildThemeOption(
          context,
          ref,
          AppThemeMode.light,
          loc.themeLight,
          Icons.light_mode,
          _selectedTheme,
        ),
        _buildThemeOption(
          context,
          ref,
          AppThemeMode.dark,
          loc.themeDark,
          Icons.dark_mode,
          _selectedTheme,
        ),
        _buildThemeOption(
          context,
          ref,
          AppThemeMode.universal,
          loc.themeUniversal,
          Icons.settings_system_daydream,
          _selectedTheme,
        ),
        _buildThemeOption(
          context,
          ref,
          AppThemeMode.orange,
          loc.themeOrange,
          Icons.wb_sunny,
          _selectedTheme,
        ),
      ],
    );
  }

  /// Build individual theme option
  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    AppThemeMode theme,
    String title,
    IconData icon,
    AppThemeMode? selectedTheme,
  ) {
    final isSelected = theme == selectedTheme;
    
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTheme = theme;
          });
          ref.read(themeProvider.notifier).setTheme(theme);
        },
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          child: isSelected
            ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            : null,
        ),
      ),
      title: Text(title),
      trailing: Icon(icon),
      onTap: () {
        setState(() {
          _selectedTheme = theme;
        });
        ref.read(themeProvider.notifier).setTheme(theme);
      },
    );
  }
}
