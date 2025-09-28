
import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test_dev/models/login_response.dart';
import 'package:flutter_test_dev/services/auth_service.dart';
import 'package:flutter_test_dev/storage/app_prefs.dart';

import '../dio_client.dart';

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor(this._client);

  final DioClient _client;
  bool _isRefreshing = false;
  final List<Completer<void>> _refreshWaiters = <Completer<void>>[];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final List<ConnectivityResult> connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: 'No internet connection',
        ),
      );
    }
    final String? token = await _getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final int? status = err.response?.statusCode;
    final RequestOptions failedOptions = err.requestOptions;
    //refresh token
    if (status == 401) {
      try {
        await _refreshTokenIfNeeded();
        final RequestOptions requestOptions = failedOptions;
        final String? token = await _getAccessToken();
        if (token != null && token.isNotEmpty) {
          requestOptions.headers['Authorization'] = 'Bearer $token';
        }
        final Response retryResponse = await _client.dio.fetch(requestOptions);
        return handler.resolve(retryResponse);
      } catch (_) {
        return handler.next(err);
      }
    }

    handler.next(err);
  }

  Future<void> _refreshTokenIfNeeded() async {
    if (_isRefreshing) {
      final Completer<void> waiter = Completer<void>();
      _refreshWaiters.add(waiter);
      return waiter.future;
    }
    _isRefreshing = true;
    try {
      final AppPrefs prefs = await AppPrefs.instance();
      final String? refresh = prefs.getString(PrefKey.refreshToken);
      if (refresh == null || refresh.isEmpty) {
        throw StateError('No refresh token');
      }
      final resp = await AuthService().refreshToken(refreshToken: refresh);
      if (resp.isSuccess) {
        final LoginResponse data = resp.data!;
        final String access = data.accessToken;
        await prefs.setString(PrefKey.accessToken, access);
        final int? exp = _decodeJwtExp(access);
        if (exp != null) {
          await prefs.setInt(PrefKey.accessExp, exp);
        }
      } else {
        //'Refresh failed'
        throw resp.error!;
      }
    } finally {
      _isRefreshing = false;
      for (final Completer<void> c in _refreshWaiters) {
        if (!c.isCompleted) c.complete();
      }
      _refreshWaiters.clear();
    }
  }

  Future<String?> _getAccessToken() async {
    final AppPrefs prefs = await AppPrefs.instance();
    return prefs.getString(PrefKey.accessToken);
  }

  int? _decodeJwtExp(String jwt) {
    try {
      final List<String> parts = jwt.split('.');
      if (parts.length != 3) return null;
      String payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      switch (payload.length % 4) {
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }
      final Map<String, dynamic> payloadMap = json.decode(utf8.decode(base64.decode(payload))) as Map<String, dynamic>;
      final dynamic exp = payloadMap['exp'];
      if (exp is int) return exp;
      if (exp is String) return int.tryParse(exp);
      return null;
    } catch (_) {
      return null;
    }
  }
}
