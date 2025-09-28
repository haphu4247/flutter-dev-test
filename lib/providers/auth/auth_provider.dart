import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_dev/base/api_client/base_api.dart';
import 'package:flutter_test_dev/providers/auth/auth_state.dart';
import 'package:flutter_test_dev/services/auth_service.dart';
import '../../storage/app_prefs.dart';
import '../../models/login_response.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authService) : super(const AuthState(loggedIn: false, initialized: false)) {
    _load();
  }

  final AuthService _authService;

  Future<void> _load() async {
    final AppPrefs prefs = await AppPrefs.instance();
    final String? access = prefs.getString(PrefKey.accessToken);
    final String? refresh = prefs.getString(PrefKey.refreshToken);

    final bool valid = access != null && access.isNotEmpty && refresh != null && refresh.isNotEmpty;

    state = state.copyWith(
      loggedIn: valid,
      accessToken: access,
      refreshToken: refresh,
      initialized: true,
    );
  }

  Future<void> logIn({required String username, required String password}) async {
    final ApiResult<LoginResponse> result = await _authService.login(username: username, password: password);
    if (result.isFailure) {
      //handle show dialog with 'text' when call logIn function.
      state = state.copyWith(
        loggedIn: false,
        accessToken: null,
        refreshToken: null,
        initialized: true,
        errorMessage: result.error?.message,
      );
      return;
    }
    final resp = result.data;
    if (resp != null) {
      final String access = resp.accessToken;
      final String refresh = resp.refreshToken;


      final AppPrefs prefs = await AppPrefs.instance();
      await prefs.setString(PrefKey.accessToken, access);
      await prefs.setString(PrefKey.refreshToken, refresh);
      await prefs.setBool(PrefKey.loggedIn, true);

      state = state.copyWith(
        loggedIn: true,
        accessToken: access,
        refreshToken: refresh,
        initialized: true,
      );
    }
  }

  Future<void> logOut() async {
    final AppPrefs prefs = await AppPrefs.instance();
    await prefs.remove(PrefKey.accessToken);
    await prefs.remove(PrefKey.refreshToken);
    await prefs.remove(PrefKey.accessExp);
    await prefs.remove(PrefKey.profileJson); // Clear cached profile
    await prefs.setBool(PrefKey.loggedIn, false);
    // Note: We intentionally keep locale preference for better UX
    state = state.copyWith(loggedIn: false, clearTokens: true);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(AuthService());
});


