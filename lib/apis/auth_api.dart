import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:biskychat_aug23/features/profile/controllers/profile_controller.dart';
import 'package:biskychat_aug23/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../core/appwrite_providers.dart';
import '../core/failure.dart';
import '../core/type_defs.dart';

abstract class IAuthApi {
  FutureEither<Token> createSession(
      {required String userId, required String phone});
  FutureEither<Session> verifySession(
      {required String userId, required String secret});
  Future<User?> getCurrentAccount();
  FutureEitherVoid logout();
}
// -----------------------------------------------------------------------------

class AuthApi implements IAuthApi {
  final Account _account;
  final ProfileController _profileController;
  AuthApi({
    required Account account,
    required ProfileController profileController,
  })  : _account = account,
        _profileController = profileController;

  @override
  FutureEither<Token> createSession(
      {required String userId, required String phone}) async {
    try {
      final token =
          await _account.createPhoneSession(userId: userId, phone: phone);
      return right(token);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? 'Something went wrong!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<Session> verifySession(
      {required String userId, required String secret}) async {
    try {
      Session session =
          await _account.updatePhoneSession(userId: userId, secret: secret);
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<User?> getCurrentAccount() async {
    try {
      final user = await _account.get();
      _profileController.setProfile(
        userModel: UserModel(
          id: user.$id,
          name: user.name,
          phone: user.phone,
          imageUrl: user.prefs.data['imageUrl'],
          // fcmToken: user.prefs.data['fcmToken'],
        ),
      );
      return user;
    } on AppwriteException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  FutureEitherVoid logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
}

// -----------------------------------------------------------------------------
final authApiProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  final profileController = ref.watch(profileControllerProvider.notifier);
  return AuthApi(
    account: account,
    profileController: profileController,
  );
});
