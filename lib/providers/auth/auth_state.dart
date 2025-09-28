
class AuthState {
  const AuthState({
    required this.loggedIn,
    this.initialized = false,
    this.accessToken,
    this.refreshToken,
    this.errorMessage
  });
  //when loading the app, we need to check if the user is logged in or not
  final bool loggedIn;
  //whether the auth state has been initialized
  final bool initialized;
  final String? accessToken;
  final String? refreshToken;
  final String? errorMessage;

  AuthState copyWith({
    bool? loggedIn,
    bool? initialized,
    String? accessToken,
    String? refreshToken,
    String? errorMessage,
    bool clearTokens = false,
  }) => AuthState(
    loggedIn: loggedIn ?? this.loggedIn,
    initialized: initialized ?? this.initialized,
    accessToken: clearTokens ? null : (accessToken ?? this.accessToken),
    refreshToken: clearTokens ? null : (refreshToken ?? this.refreshToken),
    errorMessage: errorMessage ?? this.errorMessage,
  );
}