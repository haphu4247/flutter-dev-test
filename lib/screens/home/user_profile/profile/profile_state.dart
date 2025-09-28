import 'package:flutter_test_dev/models/login_response.dart';

class ProfileState {
  const ProfileState({
    required this.isLoading,
    this.profile,
    this.errorMessage,
  });

  final bool isLoading;
  final LoginResponse? profile;
  final String? errorMessage;

  ProfileState copyWith({
    bool? isLoading,
    LoginResponse? profile,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get hasProfile => profile != null;
}
