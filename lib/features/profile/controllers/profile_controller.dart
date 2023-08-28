import 'package:biskychat_aug23/apis/user_api.dart';
import 'package:biskychat_aug23/main.dart';
import 'package:biskychat_aug23/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileController extends StateNotifier<UserModel?> {
  final UserApi _userApi;
  ProfileController({required UserApi userApi})
      : _userApi = userApi,
        super(null);

  void setProfile({required UserModel userModel}) {
    state = UserModel(
      id: userModel.id,
      name: userModel.name,
      phone: userModel.phone,
      imageUrl: userModel.imageUrl,
      // fcmToken: userModel.fcmToken,
    );
  }

  void updateUserProfile(BuildContext context, UserModel userModel) async {
    final userData =
        await _userApi.createOrUpdateUserProfile(userModel: userModel);

    userData.fold(
      (l) => null,
      (r) {
        state = UserModel(
          id: r.$id,
          name: r.data['name'],
          phone: r.data['phone'],
          imageUrl: r.data['imageUrl'],
          // fcmToken: r.data['fcmToken'] ?? '',
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const BiskyChatApp(),
          ),
          (route) => false,
        );
      },
    );
  }
}
// -----------------------------------------------------------------------------

final profileControllerProvider =
    StateNotifierProvider<ProfileController, UserModel?>((ref) {
  final userApi = ref.watch(userApiProvider);
  return ProfileController(userApi: userApi);
});
