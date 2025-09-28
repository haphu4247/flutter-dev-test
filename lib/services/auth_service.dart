import 'package:flutter_test_dev/base/api_client/base_api.dart';
import '../models/login_response.dart';

class AuthService extends BaseApi {
  Future<ApiResult<LoginResponse>> login({required String username, required String password}) async {
    return request<LoginResponse>(path: '/auth/login', method: BaseHttpMethod.post, fromJson: (json) => LoginResponse.fromJson(json), data: {
      'username': username,
    'password': password,
    'expiresInMins': 1,
    });
  }

  Future<ApiResult<LoginResponse>> refreshToken({required String refreshToken}) async {
    return request<LoginResponse>(path: '/auth/refresh', method: BaseHttpMethod.post, fromJson: (json) => LoginResponse.fromJson(json), data: {
          'refreshToken': refreshToken,
          'expiresInMins': 1,
        });
  }
}


