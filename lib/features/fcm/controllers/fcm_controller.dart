// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:biskychat_aug23/apis/user_api.dart';
import 'package:biskychat_aug23/features/auth/controllers/auth_controller.dart';
import 'package:biskychat_aug23/models/message_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../constants/appwrite_constants.dart';
import '../../../models/user_model.dart';

class FcmController extends StateNotifier<String> {
  final UserApi _userApi;
  FcmController({required UserApi userApi})
      : _userApi = userApi,
        super('');

  void createFcmToken(WidgetRef ref, String userId) {
    FirebaseMessaging.instance.getToken().then((value) {
      _userApi.updateUserFcmToken(userId, value!);
      ref.read(authControllerProvider).copyWith(fcmToken: value);
    });
  }

  sendFcm(
      MessageModel message, UserModel currentUser, UserModel otherUser) async {
    final body = {
      'fromId': currentUser.uid,
      'fromName': currentUser.name,
      'message': message.text,
    };
    sendPayload(otherUser.fcmToken!, body);
  }

  sendPayload(String reciverToken, Map<String, dynamic> data) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${AppwriteConstants.fcmServerKey}',
      },
      body: jsonEncode({'data': data, 'to': reciverToken}),
    );
  }
}
// -----------------------------------------------------------------------------

final fcmControllerProvider =
    StateNotifierProvider<FcmController, String>((ref) {
  final userApi = ref.watch(userApiProvider);
  return FcmController(userApi: userApi);
});
