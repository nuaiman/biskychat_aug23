import 'package:appwrite/models.dart';
import 'package:biskychat_aug23/features/auth/views/phone_input_view.dart';
import 'package:biskychat_aug23/main.dart';
import '../../../apis/auth_api.dart';
import '../../../core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../views/phone_otp_view.dart';

class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;
  AuthController({required AuthApi authApi})
      : _authApi = authApi,
        super(false);

  void createSession(
      {required BuildContext context, required String phoneNumber}) async {
    state = true;

    final token = await _authApi.createSession(
        userId: phoneNumber.substring(1), phone: phoneNumber);

    token.fold(
      (l) {
        state = false;
        showSnackbar(context, l.message);
      },
      (r) {
        state = false;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PhoneOtpView(
            phoneNumber: phoneNumber,
          ),
        ));
      },
    );
  }

  void verifySession({
    required BuildContext context,
    required String userId,
    required String otp,
  }) async {
    state = true;
    final result = await _authApi.verifySession(userId: userId, secret: otp);

    await Future.delayed(const Duration(seconds: 2));

    result.fold(
      (l) {
        state = false;
        showSnackbar(context, l.message);
      },
      (r) {
        state = false;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BiskyChatApp(),
          ),
          (route) => false,
        );
      },
    );
  }

  Future<User?> getCurrentAccount() async {
    User? user = await _authApi.getCurrentAccount();
    return user;
  }

  void logout(BuildContext context) async {
    final result = await _authApi.logout();
    result.fold(
      (l) => null,
      (r) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const PhoneInputView(),
          ),
          (route) => false),
    );
  }
}
// -----------------------------------------------------------------------------

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authApi = ref.watch(authApiProvider);
  return AuthController(authApi: authApi);
});

final getCurrentAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getCurrentAccount();
});
