import 'package:biskychat_aug23/features/chats/controllers/chats_controller.dart';
import 'package:biskychat_aug23/models/message_model.dart';
import 'package:biskychat_aug23/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../../constants/appwrite_constants.dart';
import '../../../models/chat_model.dart';

class MessagingView extends ConsumerStatefulWidget {
  final UserModel currentUser;
  final UserModel otherUser;
  final String mKey;
  const MessagingView({
    super.key,
    required this.currentUser,
    required this.otherUser,
    required this.mKey,
  });

  @override
  ConsumerState<MessagingView> createState() => _MessagingViewState();
}

class _MessagingViewState extends ConsumerState<MessagingView> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void sendChat() {
    MessageModel message = MessageModel(
      id: const Uuid().v4(),
      key: widget.mKey,
      sId: widget.currentUser.uid,
      rId: widget.otherUser.uid,
      text: _textController.text,
      sendDate: DateTime.now().toIso8601String(),
    );
    ref
        .read(chatsControllerProvider.notifier)
        .sendChat(ref: ref, message: message, currentUser: widget.currentUser);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ChatModel? chatModel = ref
        .watch(chatsControllerProvider.notifier)
        .getAllMessagesForAmKey(mKey: widget.mKey);

    ref.watch(chatsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUser.name),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.otherUser.imageUrl),
            ),
          ),
        ],
      ),
      body: Form(
        child: Column(
          children: [
            Flexible(
              child: chatModel == null
                  ? Container()
                  : ListView.builder(
                      reverse: true,
                      addAutomaticKeepAlives: true,
                      itemCount: chatModel.messages.length,
                      itemBuilder: (context, index) {
                        final chat = chatModel.messages[index];
                        if (chat.read == false) {
                          ref
                              .read(chatsControllerProvider.notifier)
                              .updateMessageSeen(chat.id.toString());
                        }
                        return ListTile(
                          leading: Text(
                            chat.text,
                          ),
                          subtitle: Text(chat.sendDate),
                          trailing: chat.read == false
                              ? const Icon(Icons.done)
                              : const Icon(
                                  Icons.done_all,
                                  color: Colors.green,
                                ),
                        );
                      },
                    ),
            ),
            Container(
              height: 55,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Container(
                    height: 55,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ref.watch(getLatestMessageProvider).when(
                          data: (data) {
                            if (data.events.contains(
                                'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.messagesCollection}.documents.*.create')) {
                              ref
                                  .read(chatsControllerProvider.notifier)
                                  .addChatToState(
                                    ref: ref,
                                    currentUser: widget.currentUser,
                                    message: MessageModel.fromMap(data.payload),
                                  );
                            }
                            if (data.events.contains(
                                'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.messagesCollection}.documents.*.update')) {
                              ref
                                  .read(chatsControllerProvider.notifier)
                                  .changeMessageSeen(
                                    data.payload['id'],
                                    data.payload,
                                  );
                            }

                            return TextField(
                              controller: _textController,
                              decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8),
                                  border: OutlineInputBorder(),
                                  hintText: 'Message'),
                            );
                          },
                          error: (error, stackTrace) =>
                              ErrorPage(error: error.toString()),
                          loading: () => TextField(
                            controller: _textController,
                            decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(),
                                hintText: 'Message'),
                          ),
                        ),
                  ),
                  Container(
                    height: 55,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: CircleAvatar(
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: IconButton(
                          onPressed: sendChat,
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
