import 'package:biskychat_aug23/apis/chats_api.dart';
import 'package:biskychat_aug23/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatsController extends StateNotifier<List<MessageModel>> {
  final ChatsApi _chatsApi;
  ChatsController({required ChatsApi chatsApi})
      : _chatsApi = chatsApi,
        super([]);

  void sendChat({required MessageModel message}) async {
    _chatsApi.sendChat(message: message);
  }
}
// -----------------------------------------------------------------------------

final chatsControllerProvider =
    StateNotifierProvider<ChatsController, List<MessageModel>>((ref) {
  final chatsApi = ref.watch(chatsApiProvider);
  return ChatsController(chatsApi: chatsApi);
});
