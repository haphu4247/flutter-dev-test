import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_dev/l10n/generated/app_localizations.dart';
import 'package:flutter_test_dev/router/app_route_path.dart';

import '../../providers/auth/auth_provider.dart';

final loginLoadingProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final bool isLoading = ref.watch(loginLoadingProvider);

    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.loginTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: loc.emailLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: loc.passwordLabel),
              obscureText: true,
              onSubmitted: (_) => onSubmit(context: context, ref: ref, isLoading: isLoading, username: usernameController.text, password: passwordController.text,),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (isLoading){return;}
                onSubmit(context: context, ref: ref, isLoading: isLoading, username: usernameController.text, password: passwordController.text,);
              },
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(loc.signIn),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onSubmit({required BuildContext context, required WidgetRef ref, required bool isLoading,required String username, required String password,}) async {
    if (isLoading) return;
    ref.read(loginLoadingProvider.notifier).state = true;
    try {
      await ref.read(authProvider.notifier).logIn(
        username: username.trim(),
        password: password.trim(),
      );

      if (ref.read(authProvider).loggedIn) {
        if (context.mounted) {
          AppRoutePath.home.go(context);
        }
        return;
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.loginFailed(ref.read(authProvider).errorMessage ?? AppLocalizations.of(context)!.profileErrorUnknown))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.loginFailed(e.toString()))),
        );
      }
    } finally {
      ref.read(loginLoadingProvider.notifier).state = false;
    }
  }
}


