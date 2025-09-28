import 'package:dio/dio.dart';

import 'interceptor/refresh_token_interceptor.dart';

class DioClient {
  DioClient._internal()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://dummyjson.com',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json'
            }
          ),
        ) {
    dio.interceptors.add(RefreshTokenInterceptor(this));
  }

  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  final Dio dio;
}

