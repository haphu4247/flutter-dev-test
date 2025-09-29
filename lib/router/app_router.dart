import 'package:flutter/material.dart';
import 'package:flutter_test_dev/l10n/generated/app_localizations.dart';
import 'package:flutter_test_dev/models/login_response.dart';
import 'package:flutter_test_dev/router/app_route_path.dart';
import 'package:flutter_test_dev/screens/auth/login_screen.dart';
import 'package:flutter_test_dev/screens/home/user_profile/user_profile_screen.dart';
import 'package:go_router/go_router.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/home/home_screen.dart';

GoRouter createRouter({required ValueGetter<bool> isAuthenticated, required GlobalKey<NavigatorState> navigatorKey}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutePath.splash.path,
    routes: [
      GoRoute(
        path: AppRoutePath.splash.path,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutePath.login.path,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutePath.home.path,
        builder: (context, state) => const HomeScreen(),
        routes: [
          
        ],
      ),
      GoRoute(
        path: AppRoutePath.userProfile.path,
        builder: (context, state) {
          final profile = state.extra as LoginResponse?;
          if (profile == null) {
            // If no profile data is passed, redirect to home or show error
            final loc = AppLocalizations.of(context)!;
            return Scaffold(
              body: Center(
                child: Text(loc.profileDataNotAvailable),
              ),
            );
          }
          return UserProfileScreen(profile: profile);
        },
      ),
    ],
  );
}


