import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_dev/l10n/generated/app_localizations.dart';
import 'package:flutter_test_dev/router/app_route_path.dart';
import 'package:go_router/go_router.dart';
import 'package:app_settings/app_settings.dart';

import 'providers/auth/auth_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/network_provider.dart';
import 'providers/theme_provider.dart';
import 'router/app_router.dart';
import 'widgets/settings_button.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  final GlobalKey<NavigatorState> _rootNavKey = GlobalKey<NavigatorState>();
  bool _offlineDialogShown = false;

  late final GoRouter _router = createRouter(
    isAuthenticated: () => ref.read(authProvider).loggedIn,
    navigatorKey: _rootNavKey,
  );

  @override
  Widget build(BuildContext context) {
    final Locale? locale = ref.watch(localeProvider);
    final AppThemeMode currentThemeMode = ref.watch(themeProvider);

    ref.listen<bool>(networkProvider, (prev, next) {
      final BuildContext? navContext = _rootNavKey.currentContext;
      if (next == false && !_offlineDialogShown) {
        _offlineDialogShown = true;
        showDialog(
          context: navContext ?? context,
          barrierDismissible: false,
          builder: (ctx) {
            final loc = AppLocalizations.of(ctx)!;
            return AlertDialog(
              title: Text(loc.networkError),
              content: Text(loc.networkErrorDescription),
              actions: [
                TextButton(
                  onPressed: () {
                    // Close the dialog first
                    AppRoutePath.back(navContext ?? context);
                    // Navigate to WiFi settings
                    AppSettings.openAppSettings(type: AppSettingsType.wifi);
                  },
                  child: Text(loc.networkErrorOk),
                ),
              ],
            );
          },
        );
      } else if (next == true && _offlineDialogShown) {
        _offlineDialogShown = false;
        if (navContext != null) {
          // Navigator.of(navContext, rootNavigator: true).pop();
          AppRoutePath.back(navContext);
        }
      }
    });

    return MaterialApp.router(
      locale: locale,
      theme: getCurrentThemeData(currentThemeMode),
      scrollBehavior: MaterialScrollBehavior().copyWith(
      dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, 
                 PointerDeviceKind.stylus, PointerDeviceKind.unknown},
    ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
      title: 'Flutter Test Dev',
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              SettingsButton(currentContext: _rootNavKey.currentContext,),
            ],
          ),
          body: child,
        );
      },
    );
  }
}
