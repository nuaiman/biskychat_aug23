import 'package:biskychat_aug23/apis/chats_api.dart';
import 'package:biskychat_aug23/features/friends/controllers/friends_controller.dart';
import 'package:biskychat_aug23/models/message_model.dart';
import 'package:biskychat_aug23/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/chat_model.dart';

class ChatsController extends StateNotifier<List<ChatModel>> {
  final ChatsApi _chatsApi;
  ChatsController({required ChatsApi chatsApi})
      : _chatsApi = chatsApi,
        super([]);

  void sendChat({required MessageModel message}) async {
    _chatsApi.sendChat(message: message);
  }

  Future<void> getAllChats({
    required WidgetRef ref,
    required String currentUid,
    required UserModel currentUser,
  }) async {
    final list = await _chatsApi.getAllChats(currentUid: currentUid);
    final mList = list.map((e) => MessageModel.fromMap(e.data)).toList();

    List<ChatModel> groupMessagesIntoChats(List<MessageModel> messageList) {
      Map<String, List<MessageModel>> chatMap = {};

      for (MessageModel message in messageList) {
        if (!chatMap.containsKey(message.key)) {
          chatMap[message.key] = [];
        }

        chatMap[message.key]!.add(message);
      }

      List<ChatModel> chatList = chatMap.entries.map((entry) {
        final id = entry.value.last.rId == currentUid
            ? entry.value.last.sId
            : entry.value.last.rId;

        return ChatModel(
          key: entry.key,
          messages: entry.value,
          currentUser: currentUser,
          otherUser:
              ref.read(friendsControllerProvider.notifier).getUserById(uId: id),
        );
      }).toList();

      // print(chatList);

      return chatList;
    }

    state = groupMessagesIntoChats(mList);
  }
}
// -----------------------------------------------------------------------------

final chatsControllerProvider =
    StateNotifierProvider<ChatsController, List<ChatModel>>((ref) {
  final chatsApi = ref.watch(chatsApiProvider);
  return ChatsController(chatsApi: chatsApi);
});
