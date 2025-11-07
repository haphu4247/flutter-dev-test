import 'dart:async';

import 'env.dart';

abstract class BaseEnvModel {
  const BaseEnvModel({required this.env});

  final Env env;

  String get appIcon;

  FutureOr<dynamic> initConfig();

  String get apiHost;

  bool get enableCrashlytics => false;
}
