import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:biskychat_aug23/constants/appwrite_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/appwrite_providers.dart';

abstract class IFriendsApi {
  Future<DocumentList> getAllFriends({required String currentUserId});
}
// -----------------------------------------------------------------------------

class FriendsApi implements IFriendsApi {
  final Databases _databases;
  FriendsApi({
    required Databases databases,
  }) : _databases = databases;

  @override
  Future<DocumentList> getAllFriends({required String currentUserId}) async {
    final listOfFriends = await _databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      queries: [
        Query.notEqual(
          '\$id',
          currentUserId,
        ),
      ],
    );
    return listOfFriends;
  }
}
// -----------------------------------------------------------------------------

final friendsApiProvider = Provider((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  return FriendsApi(
    databases: databases,
  );
});
