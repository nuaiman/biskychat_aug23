import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:biskychat_aug23/apis/storage_api.dart';
import 'package:biskychat_aug23/constants/appwrite_constants.dart';
import 'package:biskychat_aug23/core/appwrite_providers.dart';
import 'package:biskychat_aug23/core/failure.dart';
import 'package:biskychat_aug23/core/type_defs.dart';
import 'package:biskychat_aug23/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

abstract class IUserApi {
  FutureEither<Document> createOrUpdateUserProfile(
      {required UserModel userModel});
}
// -----------------------------------------------------------------------------

class UserApi implements IUserApi {
  final Account _account;
  final StorageApi _storageApi;
  final Databases _databases;
  UserApi({
    required Account account,
    required StorageApi storageApi,
    required Databases databases,
  })  : _account = account,
        _storageApi = storageApi,
        _databases = databases;

  @override
  FutureEither<Document> createOrUpdateUserProfile(
      {required UserModel userModel}) async {
    // update storage
    final imageUrl =
        await _storageApi.uploadImage(userModel.imageUrl, userModel.id);

    // update account prefs
    await _account.updateName(name: userModel.name);
    await _account.updatePrefs(
      prefs: {
        'name': userModel.name,
        'phone': userModel.phone,
        'imageUrl': imageUrl,
        // 'fcmToken': userModel.fcmToken,
      },
    );

    try {
      final document = await _databases.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: userModel.id,
          data: {
            'name': userModel.name,
            'phone': userModel.phone,
            'imageUrl': imageUrl,
            // 'fcmToken': userModel.fcmToken,
          });
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      if (e.code == 404) {
        final document = await _databases.createDocument(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.usersCollection,
            documentId: userModel.id,
            data: {
              'name': userModel.name,
              'phone': userModel.phone,
              'imageUrl': imageUrl,
              // 'fcmToken': userModel.fcmToken,
            });
        return right(document);
      }
      return left(Failure(e.toString(), stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
}
// -----------------------------------------------------------------------------

final userApiProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  final storageApi = ref.watch(storageApiProvider);
  final databases = ref.watch(appwriteDatabaseProvider);
  return UserApi(
    account: account,
    storageApi: storageApi,
    databases: databases,
  );
});
