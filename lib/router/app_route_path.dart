
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoutePath {
  splash('/'),
  login('/login'),
  home('/home'),
  userProfile('/user_profile');
  final String path;
  const AppRoutePath(this.path);

  static void back(BuildContext context, {Object? data}) {
    if (context.mounted) {
      if (context.canPop()) {
        context.pop(data);
      }
    }
  }

  void go(BuildContext context) {
    if (context.mounted) {
      context.go(path);
    }
  }
  
  /// Navigate to user profile with LoginResponse data
  void goWithObject(BuildContext context, Object? data) {
    if (context.mounted) {
      context.go(path, extra: data);
    }
  }
}