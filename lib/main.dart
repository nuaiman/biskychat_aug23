import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/error_page.dart';
import 'common/loading_page.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/views/create_phone_session_view.dart';
import 'features/auth/views/update_user_profile_view.dart';
import 'features/dashboard/views/dashboard_view.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: ref.watch(getCurrentAccountProvider).when(
            data: (data) {
              if (data == null) {
                return const CreatePhoneSessionView();
              } else if (data.name.isEmpty) {
                return const UpdateUserProfileView();
              } else {
                return const DashboardView();
              }
            },
            error: (error, stackTrace) => ErrorPage(error: error.toString()),
            loading: () => const LoadingPage(),
          ),
    );
  }
}


  // if (data.events.contains(
  //               'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.messagesCollection}.documents.*.create')) {
            
  //             ref
  //                 .read(chatsControllerProvider.notifier)
  //                 .addChatToState(message: MessageModel.fromMap(data.payload));
  //           }
