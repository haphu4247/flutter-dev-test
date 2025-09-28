import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkProvider = StateNotifierProvider<NetworkNotifier, bool>((ref) {
  return NetworkNotifier(ref);
});

class NetworkNotifier extends StateNotifier<bool> {
  NetworkNotifier(this._ref) : super(true) {
    _subscription = _ref.listen<AsyncValue<ConnectivityResult>>(
      connectivityStreamProvider,
      (previous, next) {
        if (next.hasValue) {
          state = next.value != ConnectivityResult.none;
        }
      },
      fireImmediately: true,
    );
  }

  final Ref _ref;
  late final ProviderSubscription<AsyncValue<ConnectivityResult>> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }

  final connectivityStreamProvider = StreamProvider<ConnectivityResult>((ref) {
  final Connectivity connectivity = Connectivity();
  final StreamController<ConnectivityResult> controller = StreamController.broadcast();

  connectivity.checkConnectivity().then((value) {
    controller.add(value.first);
    return value;
  },);

  final StreamSubscription sub = connectivity.onConnectivityChanged.listen((event) {
    controller.add(event.first);
  },);
  ref.onDispose(() async {
    await sub.cancel();
    await controller.close();
  });
  return controller.stream;
});
}


