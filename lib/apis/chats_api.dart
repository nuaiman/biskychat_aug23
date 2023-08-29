import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:biskychat_aug23/constants/appwrite_constants.dart';
import 'package:biskychat_aug23/core/type_defs.dart';
import 'package:biskychat_aug23/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/appwrite_providers.dart';

abstract class IChatsApi {
  void sendChat({required MessageModel message});

  Future<List<Document>> getAllChats({required String currentUid});

  Stream<RealtimeMessage> getLatestMessage();

  FutureVoid updateMessageSeen(String chatId);
}
// -----------------------------------------------------------------------------

class ChatsApi implements IChatsApi {
  final Databases _databases;
  final Realtime _realtime;
  ChatsApi({
    required Databases databases,
    required Realtime realtime,
  })  : _databases = databases,
        _realtime = realtime;

  @override
  void sendChat({required MessageModel message}) async {
    await _databases.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.messagesCollection,
      documentId: message.id,
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
        Query.orderDesc('\$createdAt'),
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
        Query.orderDesc('\$createdAt'),
      ],
    );
    final list2 = document2.documents;

    final list = list1 + list2;

    return list;
  }

  @override
  Stream<RealtimeMessage> getLatestMessage() {
    final realtime = _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.messagesCollection}.documents'
    ]).stream;
    return realtime;
  }

  @override
  FutureVoid updateMessageSeen(String chatId) async {
    await _databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.messagesCollection,
        documentId: chatId,
        data: {
          'read': true,
        });
  }
}
// -----------------------------------------------------------------------------

final chatsApiProvider = Provider((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return ChatsApi(
    databases: databases,
    realtime: realtime,
  );
});
