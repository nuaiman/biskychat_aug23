import 'package:appwrite/models.dart';
import 'package:biskychat_aug23/constants/appwrite_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../apis/auth_api.dart';
import '../../../apis/user_api.dart';
import '../../../core/utils.dart';
import '../../../main.dart';
import '../../../models/user_model.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../views/create_phone_session_view.dart';
import '../views/verify_phone_session.dart';

class AuthController extends StateNotifier<UserModel> {
  final AuthApi _authApi;
  final UserApi _userApi;
  AuthController({required AuthApi authApi, required UserApi userApi})
      : _authApi = authApi,
        _userApi = userApi,
        super(UserModel(
          uid: '',
          name: '',
          imageUrl: '',
        ));

  void createPhoneSession(
      {required BuildContext context, required String phoneNumber}) async {
    final result = await _authApi.createPhoneSession(
      userId: phoneNumber.substring(1),
      phone: phoneNumber,
    );

    result.fold(
      (l) => showSnackbar(context, l.message),
      (r) {
        state = state.copyWith(uid: r.userId);
        showSnackbar(context, 'Session creation was successful.');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerifyPhoneSessionView(
              userId: r.userId,
              phoneNumber: '+${r.userId}',
            ),
          ),
        );
      },
    );
  }

  void verifyPhoneSession({
    required BuildContext context,
    required String userId,
    required String otp,
  }) async {
    final result = await _authApi.verifyPhoneSession(
      userId: userId,
      otp: otp,
    );
    result.fold(
      (l) => showSnackbar(context, l.message),
      (r) {
        showSnackbar(context, 'Session verification was successful.');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const BiskyChatApp(),
          ),
        );
      },
    );
  }

  void updateCurrentUserProfile({
    required BuildContext context,
    required String userName,
    required String imagePath,
  }) async {
    final user = await _userApi.updateCurrentUserProfile(
      userName: userName,
      imagePath: imagePath,
    );

    user.fold(
      (l) => null,
      (r) {
        state = state.copyWith(
          uid: r.$id,
          name: r.name,
          imageUrl: r.prefs.data['imageUrl'],
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const DashboardView(),
          ),
          (route) => false,
        );
      },
    );
  }

  Future<User?> getCurrentAccount() async {
    final user = await _authApi.getCurrentAccount();
    if (user != null) {
      state = state.copyWith(
          uid: user.$id,
          name: user.name,
          // imageUrl: user.prefs.data['imageUrl'],
          imageUrl: AppwriteConstants.imageUrl(user.$id));
    }
    return user;
  }

  void logout(BuildContext context) async {
    final result = await _authApi.logout();
    result.fold(
      (l) => null,
      (r) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const CreatePhoneSessionView(),
          ),
          (route) => false),
    );
  }
}
// -----------------------------------------------------------------------------

final authControllerProvider =
    StateNotifierProvider<AuthController, UserModel>((ref) {
  final authApi = ref.watch(authApiProvider);
  final userApi = ref.watch(userApiProvider);
  return AuthController(
    authApi: authApi,
    userApi: userApi,
  );
});

final getCurrentAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getCurrentAccount();
});
