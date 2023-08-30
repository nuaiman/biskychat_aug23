import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:biskychat_aug23/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/error_page.dart';
import 'common/loading_page.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/views/create_phone_session_view.dart';
import 'features/auth/views/update_user_profile_view.dart';
import 'features/dashboard/views/dashboard_view.dart';
import 'features/fcm/controllers/fcm_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AwesomeNotifications().initialize(
    null, //'resource://drawable/res_app_icon',//
    [
      NotificationChannel(
          channelKey: 'alerts',
          channelName: 'Alerts',
          channelDescription: 'Notification tests as alerts',
          playSound: true,
          onlyAlertOnce: true,
          groupAlertBehavior: GroupAlertBehavior.Children,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
          defaultColor: Colors.deepPurple,
          ledColor: Colors.deepPurple)
    ],
    debug: false,
  );

  FirebaseMessaging.onBackgroundMessage(myBgMsgHandler);
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
