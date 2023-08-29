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

  ChatModel? getAllMessagesForAmKey({required String mKey}) {
    if (state.isEmpty) {
      return null;
    }
    ChatModel? chatModel = state.firstWhere((element) => element.key == mKey);
    return chatModel;
  }

  Future<void> getAllChats({
    required WidgetRef ref,
    required UserModel currentUser,
  }) async {
    final list = await _chatsApi.getAllChats(currentUid: currentUser.uid);
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
        final id = entry.value.last.rId == currentUser.uid
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
      return chatList;
    }

    state = groupMessagesIntoChats(mList);
  }

  void addChatToState(
      {required WidgetRef ref,
      required UserModel currentUser,
      required MessageModel message}) {
    if (state.isEmpty) {
      getAllChats(ref: ref, currentUser: currentUser);
      return;
    }
    if (state
        .firstWhere((chat) => chat.key == message.key)
        .messages
        .contains(message)) {
      return;
    }
    state
        .firstWhere((chat) => chat.key == message.key)
        .messages
        .insert(0, message);
    final newState = [...state];
    // state = newState;
    Future.delayed(const Duration(milliseconds: 1), () {
      state = newState;
    });
  }

  void updateMessageSeen(String chatId) async {
    await _chatsApi.updateMessageSeen(chatId);
  }

  void changeMessageSeen(String chatId, Map<String, dynamic> payload) {
    state
        .firstWhere((chat) => chat.key == payload['key'])
        .messages
        .firstWhere((message) => message.id == payload['id'])
        .read = payload['read'];

    final newState = [...state];

    Future.delayed(const Duration(milliseconds: 1), () {
      state = newState;
    });
  }
}
// -----------------------------------------------------------------------------

final chatsControllerProvider =
    StateNotifierProvider<ChatsController, List<ChatModel>>((ref) {
  final chatsApi = ref.watch(chatsApiProvider);
  return ChatsController(chatsApi: chatsApi);
});

final getLatestMessageProvider = StreamProvider.autoDispose((ref) {
  final chatApi = ref.watch(chatsApiProvider);
  return chatApi.getLatestMessage();
});
