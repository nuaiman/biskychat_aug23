import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> myBgMsgHandler(RemoteMessage message) async {
  final messageMap = message.data;

  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  // if (!isAllowed) isAllowed = await displayNotificationRationale();
  if (!isAllowed) return;

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 999, // -1 is replaced by a random number
      channelKey: 'alerts',
      title: '${messageMap['fromName']} sent a message',
      body: '${messageMap['message']}',
    ),
  );
}
