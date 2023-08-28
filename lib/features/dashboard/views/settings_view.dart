import 'package:biskychat_aug23/features/auth/controllers/auth_controller.dart';
import 'package:biskychat_aug23/features/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout(context);
            },
            icon: const Icon(
              Icons.power_settings_new,
            ),
          ),
        ],
      ),
      body: const ProfileView(),
    );
  }
}
