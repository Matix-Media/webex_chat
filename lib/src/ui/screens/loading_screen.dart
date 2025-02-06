import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webex_chat/src/core/transitions.dart';
import 'package:webex_chat/src/features/authentication/auth_providers.dart';

import '../../features/authentication/login_screen.dart';
import 'overview_screen.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait gracefully for the user to understand the context of the app
      await Future.delayed(const Duration(seconds: 1));

      final identity = await ref.read(identityStorageProvider).getIdentity();
      if (identity == null) {
        if (!mounted) return;

        // Navigate to login screen
        Navigator.pushReplacement(context, fadeRoute(const LoginScreen()));
      } else {
        ref.read(identityProvider.notifier).state = identity;
        if (!mounted) return;

        // Navigate to chat screen
        Navigator.pushReplacement(context, fadeRoute(const OverviewScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              "Loading session...",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
