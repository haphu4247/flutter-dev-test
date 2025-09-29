import 'package:flutter/material.dart';
import 'package:flutter_test_dev/l10n/generated/app_localizations.dart';
import 'package:flutter_test_dev/models/login_response.dart';
import 'package:flutter_test_dev/router/app_route_path.dart';
import 'package:flutter_test_dev/storage/app_prefs.dart';

/// Full screen profile view
class UserProfileScreen extends StatelessWidget {
  final LoginResponse profile;

  const UserProfileScreen({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.profileTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppRoutePath.home.go(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.profileEditComingSoon)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.profileRefreshing)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            _buildProfileHeader(context),
            const SizedBox(height: 24),
            
            // Profile Details
            _buildProfileDetails(context, loc),
            const SizedBox(height: 24),
            
            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(profile.image),
              radius: 50,
              onBackgroundImageError: (exception, stackTrace) {
                // Handle image loading error
              },
              child: profile.image.isEmpty
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              '${profile.firstName} ${profile.lastName}',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '@${profile.username}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context, AppLocalizations loc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.profileInformation,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            _buildDetailRow(
              context: context,
              icon: Icons.email,
              label: loc.profileEmail,
              value: profile.email,
            ),
            
            _buildDetailRow(
              context: context,
              icon: Icons.person,
              label: loc.profileFullName,
              value: '${profile.firstName} ${profile.lastName}',
            ),
            
            _buildDetailRow(
              context: context,
              icon: Icons.badge,
              label: loc.profileUsername,
              value: profile.username,
            ),
            
            _buildDetailRow(
              context: context,
              icon: Icons.wc,
              label: loc.profileGender,
              value: profile.gender,
            ),
            
            _buildDetailRow(
              context: context,
              icon: Icons.fingerprint,
              label: loc.profileUserId,
              value: profile.id.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
            
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.profileEditComingSoon)),
              );
            },
            icon: const Icon(Icons.edit),
            label: Text(loc.profileEdit),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              await _handleSignOut(context);
            },
            icon: const Icon(Icons.logout),
            label: Text(loc.profileSignOut),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSignOut(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.profileSignOut),
        content: Text(loc.profileSignOutConfirm),
        actions: [
          TextButton(
            onPressed: () => AppRoutePath.back(context, data: false),
            child: Text(loc.profileCancel),
          ),
          TextButton(
            onPressed: () => AppRoutePath.back(context, data: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(loc.profileSignOut),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      try {
        final prefs = await AppPrefs.instance();
        await prefs.clear();
        
        if (context.mounted) {
          AppRoutePath.back(context);
          AppRoutePath.login.go(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.profileSignOutFailed(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
