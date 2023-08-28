import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/error_page.dart';
import 'common/loading_page.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/views/phone_input_view.dart';
import 'features/dashboard/views/dashboard_view.dart';
import 'features/profile/views/profile_view.dart';

void main() {
  runApp(const ProviderScope(child: BiskyChatApp()));
}

class BiskyChatApp extends ConsumerWidget {
  const BiskyChatApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bisky Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ref.watch(getCurrentAccountProvider).when(
        data: (data) {
          if (data != null) {
            if (data.name.isEmpty) {
              return const ProfileView();
            }
            return const DashboardView();
            // return ProfileView(userId: data.$id);
          }
          return const PhoneInputView();
        },
        error: (error, stackTrace) {
          return ErrorPage(error: error.toString());
        },
        loading: () {
          return const LoadingPage();
        },
      ),
    );
  }
}
