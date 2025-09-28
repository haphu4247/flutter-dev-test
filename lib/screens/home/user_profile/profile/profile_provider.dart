import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_dev/models/login_response.dart';
import 'package:flutter_test_dev/services/user_service.dart';
import 'package:flutter_test_dev/storage/app_prefs.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier(this._userService) : super(const ProfileState(isLoading: false)) {
    _initialize();
  }

  final UserService _userService;

  /// Initialize and load profile data
  Future<void> _initialize() async {
    await loadProfile();
  }

  /// Load profile data from cache or API
  Future<void> loadProfile() async {
    // Don't reload if already loading or if we have valid cached data
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      // First try to get cached profile
      final cachedProfile = await _getCachedProfile();
      if (cachedProfile != null) {
        state = state.copyWith(
          isLoading: false,
          profile: cachedProfile,
        );
        return;
      }

      // If no cached profile, fetch from API
      await _fetchProfileFromApi();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Force refresh profile data from API
  Future<void> refreshProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      // Clear cache first
      await _clearProfileCache();
      // Fetch fresh data from API
      await _fetchProfileFromApi();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Get cached profile data
  Future<LoginResponse?> _getCachedProfile() async {
    try {
      final prefs = await AppPrefs.instance();
      final cachedJson = prefs.getString(PrefKey.profileJson);
      
      if (cachedJson == null || cachedJson.isEmpty) {
        return null;
      }
      
      final profileData = json.decode(cachedJson) as Map<String, dynamic>;
      return LoginResponse.fromJson(profileData);
    } catch (e) {
      // Cache corrupted, return null to force fresh fetch
      print('Failed to load cached profile: $e');
      return null;
    }
  }

  /// Fetch profile data from API
  Future<void> _fetchProfileFromApi() async {
    try {
      final result = await _userService.getProfile();
      
      if (result.isSuccess && result.data != null) {
        final profile = result.data!;
        
        // Cache the profile data
        await _cacheProfile(profile);
        
        state = state.copyWith(
          isLoading: false,
          profile: profile,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result.error?.message ?? 'Failed to fetch profile',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Cache profile data
  Future<void> _cacheProfile(LoginResponse profile) async {
    try {
      final prefs = await AppPrefs.instance();
      final profileJson = json.encode(profile.toJson());
      await prefs.setString(PrefKey.profileJson, profileJson);
    } catch (e) {
      print('Failed to cache profile: $e');
      // Cache failure is not critical, don't throw error
    }
  }

  /// Clear cached profile data
  Future<void> _clearProfileCache() async {
    try {
      final prefs = await AppPrefs.instance();
      await prefs.remove(PrefKey.profileJson);
    } catch (e) {
      print('Failed to clear profile cache: $e');
    }
  }

  /// Clear profile state (useful for logout)
  void clearProfile() {
    state = const ProfileState(isLoading: true);
  }

  /// Update profile data (useful after profile updates)
  void updateProfile(LoginResponse profile) {
    state = state.copyWith(
      isLoading: false,
      profile: profile,
    );
    // Also update cache
    _cacheProfile(profile);
  }
}

// Provider for ProfileNotifier
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(UserService());
});

// Convenience providers for specific state values
final profileDataProvider = Provider<LoginResponse?>((ref) {
  return ref.watch(profileProvider).profile;
});

final profileLoadingProvider = Provider<bool>((ref) {
  return ref.watch(profileProvider).isLoading;
});

final profileErrorProvider = Provider<String?>((ref) {
  return ref.watch(profileProvider).errorMessage;
});
