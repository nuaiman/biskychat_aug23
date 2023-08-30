import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/appwrite_constants.dart';
import '../core/appwrite_providers.dart';
import '../core/type_defs.dart';
import 'storage_api.dart';

abstract class IUserApi {
  FutureEither<User> updateCurrentUserProfile({
    required String userName,
    required String imagePath,
  });
  Future<void> updateUserFcmToken(String userId, String token);
}
// -----------------------------------------------------------------------------

class UserApi implements IUserApi {
  final Account _account;
  final Databases _databases;
  final StorageApi _storageApi;
  UserApi({
    required Account account,
    required Databases databases,
    required StorageApi storageApi,
  })  : _account = account,
        _databases = databases,
        _storageApi = storageApi;

  @override
  FutureEither<User> updateCurrentUserProfile({
    required String userName,
    required String imagePath,
  }) async {
    final nameUpdatedUser = await _account.updateName(name: userName);

    final imageUrl =
        await _storageApi.uploadImage(imagePath, nameUpdatedUser.$id);

    final userDetails = await _account.updatePrefs(
      prefs: {
        'imageUrl': imageUrl,
      },
    );

    try {
      await _databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userDetails.$id,
        data: {
          'name': userName,
          'imageUrl': imageUrl,
        },
      );
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        await _databases.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: userDetails.$id,
          data: {
            'name': userName,
            'imageUrl': imageUrl,
          },
        );
      }
    }
    return right(userDetails);
  }

  @override
  Future<void> updateUserFcmToken(String userId, String token) async {
    try {
      await _databases.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: userId,
          data: {
            'fcmToken': token,
          });
      await _account.updatePrefs(
        prefs: {
          'fcmToken': token,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
// -----------------------------------------------------------------------------

final userApiProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  final databases = ref.watch(appwriteDatabaseProvider);
  final storageApi = ref.watch(storageApiProvider);
  return UserApi(
    account: account,
    databases: databases,
    storageApi: storageApi,
  );
});
