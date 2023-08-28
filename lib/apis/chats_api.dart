import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:biskychat_aug23/constants/appwrite_constants.dart';
import 'package:biskychat_aug23/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/appwrite_providers.dart';

abstract class IChatsApi {
  void sendChat({required MessageModel message});

  Future<List<Document>> getAllChats({required String currentUid});
}
// -----------------------------------------------------------------------------

class ChatsApi implements IChatsApi {
  final Databases _databases;
  ChatsApi({
    required Databases databases,
  }) : _databases = databases;

  @override
  void sendChat({required MessageModel message}) async {
    await _databases.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.messagesCollection,
      documentId: const Uuid().v4(),
      data: message.toMap(),
    );
  }

  @override
  Future<List<Document>> getAllChats({required String currentUid}) async {
    final document1 = await _databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.messagesCollection,
      queries: [
        Query.equal(
          'rId',
          currentUid,
        ),
      ],
    );
    final list1 = document1.documents;

    final document2 = await _databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.messagesCollection,
      queries: [
        Query.equal(
          'sId',
          currentUid,
        ),
      ],
    );
    final list2 = document2.documents;

    final list = list1 + list2;

    return list;
  }
}
// -----------------------------------------------------------------------------

final chatsApiProvider = Provider((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  return ChatsApi(
    databases: databases,
  );
});
