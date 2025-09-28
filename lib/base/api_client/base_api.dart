import 'package:dio/dio.dart';

import 'dio_client.dart';

class ApiResult<T> {
  const ApiResult._({this.data, this.error});

  final T? data;
  final ApiError? error;

  bool get isSuccess => data != null && error == null;
  bool get isFailure => error != null;

  static ApiResult<T> success<T>(T data) => ApiResult._(data: data);
  static ApiResult<T> failure<T>(ApiError error) => ApiResult._(error: error);
}

enum BaseHttpMethod {
  get('GET'), post('POST'), delete('DELETE');

  const BaseHttpMethod(this.method);
  final String method;
}

class ApiError {
  const ApiError({required this.message, this.statusCode, this.type,});

  final String message;
  final int? statusCode;
  final DioExceptionType? type;
}

typedef FromJson<T> = T Function(Map<String, dynamic> json);

class BaseApi {
  BaseApi() : _dio = DioClient().dio;

  final Dio _dio;

  Future<ApiResult<T>> request<T>({
    required String path,
    required BaseHttpMethod method,
    Map<String, dynamic>? query,
    dynamic data,
    required FromJson<T> fromJson,
    Options? options,
  }) async {
    try {
      final Response res = await _dio.request(
        path,
        data: data,
        queryParameters: query,
        options: (options ?? Options()).copyWith(method: method.method),
      );
      if (res.data != null) {
        if (res.data is Map<String, dynamic>) {
          return ApiResult.success(fromJson(res.data));
        } else if (res.data is List) {
          final List list = res.data as List;
          final items = list
              .map((e) => e is Map<String, dynamic> ? fromJson(e) : null)
              .whereType<T>();
          return ApiResult.success(items as T);
        }
        
      }
      return ApiResult.failure(
        ApiError(message: 'Unexpected response format', statusCode: res.statusCode),
      );
    } on DioException catch (e) {
      return ApiResult.failure(
        ApiError(
          message: _messageForDio(e),
          statusCode: e.response?.statusCode,
          type: e.type,
        ),
      );
    } catch (e) {
      return ApiResult.failure(ApiError(message: e.toString()));
    }
  }

  Future<ApiResult<List<T>>> requestList<T>({
    required String path,
    required BaseHttpMethod method,
    Map<String, dynamic>? query,
    dynamic data,
    required FromJson<T> fromJson,
    Options? options,
  }) async {
    try {
      final Response res = await _dio.request(
        path,
        data: data,
        queryParameters: query,
        options: (options ?? Options()).copyWith(method: method.method),
      );
      if (res.data != null) {
        if (res.data is List) {
          final List list = res.data as List;
          final items = list
              .map((e) => e is Map<String, dynamic> ? fromJson(e) : null)
              .whereType<T>();
          return ApiResult.success(items.toList());
        }
      }
      return ApiResult.failure(
        ApiError(message: 'Unexpected response format', statusCode: res.statusCode),
      );
    } on DioException catch (e) {
      return ApiResult.failure(
        ApiError(
          message: _messageForDio(e),
          statusCode: e.response?.statusCode,
          type: e.type,
        ),
      );
    } catch (e) {
      return ApiResult.failure(ApiError(message: e.toString()));
    }
  }

  String _messageForDio(DioException e) {
    if (e.type == DioExceptionType.connectionError) return 'No internet connection';
    if (e.type == DioExceptionType.connectionTimeout) return 'Connection timeout';
    if (e.type == DioExceptionType.receiveTimeout) return 'Receive timeout';
    if (e.type == DioExceptionType.sendTimeout) return 'Send timeout';
    if (e.response?.statusCode == 401) return 'Unauthorized';
    return e.message ?? 'Network error';
  }
}


