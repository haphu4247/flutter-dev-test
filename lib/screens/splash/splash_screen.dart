import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_dev/l10n/generated/app_localizations.dart';
import 'package:flutter_test_dev/router/app_route_path.dart';

import '../../providers/auth/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final loc = AppLocalizations.of(context)!;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(seconds: 3)).whenComplete(() {
        if (!auth.initialized) return;
        if (auth.loggedIn || ref.read(authProvider).loggedIn) {
          if (context.mounted) {
            AppRoutePath.home.go(context);
            return;
          }
        }
        if (context.mounted) {
          AppRoutePath.login.go(context);
        }
      },);
    });

    return Scaffold(
      body: Center(
        child: Text(loc.splashScreen),
      ),
    );
  }
}


