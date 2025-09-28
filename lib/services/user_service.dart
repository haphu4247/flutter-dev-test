import 'package:flutter_test_dev/base/api_client/base_api.dart';
import '../models/login_response.dart';

class UserService extends BaseApi {
  Future<ApiResult<LoginResponse>> getProfile() async {
    return request<LoginResponse>(path: '/auth/me', method: BaseHttpMethod.get, fromJson: (json) => LoginResponse.fromJson(json),);
  }
}