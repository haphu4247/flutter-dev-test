import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_dev/l10n/generated/app_localizations.dart';
import 'package:flutter_test_dev/router/app_route_path.dart';
import 'package:flutter_test_dev/screens/home/user_profile/profile/profile_provider.dart';
import 'package:flutter_test_dev/screens/home/user_profile/profile/profile_state.dart';

/// IconButton widget for navigating to user profile
class ProfileIconButton extends ConsumerWidget {
  const ProfileIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileProvider);
    final profileNotifier = ref.read(profileProvider.notifier);

    return IconButton(
      icon: profileState.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.person),
      onPressed: profileState.isLoading
          ? null
          : () => _handleProfileNavigation(context, profileState, profileNotifier, loc),
    );
  }

  /// Handle profile navigation logic
  Future<void> _handleProfileNavigation(
    BuildContext context,
    ProfileState profileState,
    ProfileNotifier profileNotifier,
    AppLocalizations loc,
  ) async {
    // Ensure profile is loaded
    if (!profileState.hasProfile) {
      await profileNotifier.loadProfile();
    }

    if (!context.mounted) return;

    // Navigate to profile screen
    if (profileState.hasProfile) {
      AppRoutePath.userProfile.go(context, data: profileState.profile);
    } else if (profileState.errorMessage != null) {
      // Show error dialog if there's an error
      await _showErrorDialog(
        context: context,
        error: profileState.errorMessage ?? loc.profileErrorUnknown,
        onRetry: () async {
          await profileNotifier.refreshProfile();
        },
      );
    } else {
      // Show error for no profile data
      await _showErrorDialog(
        context: context,
        error: loc.profileNoDataAvailable,
        onRetry: () async {
          await profileNotifier.loadProfile();
        },
      );
    }
  }

  /// Show error dialog for profile errors
  Future<void> _showErrorDialog({
    required BuildContext context,
    required String error,
    required VoidCallback onRetry,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[300],
            ),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.profileError),
          ],
        ),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => AppRoutePath.back(context),
            child: Text(AppLocalizations.of(context)!.profileCancel),
          ),
          ElevatedButton.icon(
            onPressed: () {
              AppRoutePath.back(context);
              onRetry();
            },
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context)!.profileRetry),
          ),
        ],
      ),
    );
  }
}
