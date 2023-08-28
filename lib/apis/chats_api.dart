import 'package:appwrite/appwrite.dart';
import 'package:biskychat_aug23/constants/appwrite_constants.dart';
import 'package:biskychat_aug23/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../core/appwrite_providers.dart';

abstract class IChatsApi {
  void sendChat({required MessageModel message});
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
}
// -----------------------------------------------------------------------------

final chatsApiProvider = Provider((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  return ChatsApi(
    databases: databases,
  );
});
