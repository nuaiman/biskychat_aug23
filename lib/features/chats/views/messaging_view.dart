import 'package:biskychat_aug23/features/chats/controllers/chats_controller.dart';
import 'package:biskychat_aug23/features/fcm/controllers/fcm_controller.dart';
import 'package:biskychat_aug23/models/message_model.dart';
import 'package:biskychat_aug23/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../common/error_page.dart';
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
      sName: widget.otherUser.name,
      rId: widget.otherUser.uid,
      text: _textController.text,
      sendDate: DateTime.now().toIso8601String(),
    );
    ref
        .read(chatsControllerProvider.notifier)
        .sendChat(ref: ref, message: message, currentUser: widget.currentUser);
    ref.read(fcmControllerProvider.notifier).sendFcm(
          message,
          widget.currentUser,
          widget.otherUser,
        );
    _textController.clear();
    FocusManager.instance.primaryFocus!.unfocus();
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Flexible(
                child: chatModel == null
                    ? Container()
                    : ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 5),
                        reverse: true,
                        addAutomaticKeepAlives: true,
                        itemCount: chatModel.messages.length,
                        itemBuilder: (context, index) {
                          final fullScreenWidth =
                              MediaQuery.of(context).size.width;
                          final message = chatModel.messages[index];
                          final isSentByMe =
                              message.sId == widget.currentUser.uid;
                          if (message.read == false && !isSentByMe) {
                            ref
                                .read(chatsControllerProvider.notifier)
                                .updateMessageSeen(message.id.toString());
                          }
                          return Padding(
                            padding: EdgeInsets.only(
                              right: !isSentByMe ? fullScreenWidth * 0.4 : 0,
                              left: isSentByMe ? fullScreenWidth * 0.4 : 0,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: fullScreenWidth * 0.6,
                              decoration: BoxDecoration(
                                color: isSentByMe
                                    ? Colors.green
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(10),
                                  topRight: const Radius.circular(10),
                                  bottomLeft:
                                      Radius.circular(isSentByMe ? 10 : 0),
                                  bottomRight:
                                      Radius.circular(!isSentByMe ? 10 : 0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: isSentByMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.text,
                                    textAlign: isSentByMe
                                        ? TextAlign.right
                                        : TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: isSentByMe
                                          ? Colors.white
                                          : Colors.grey.shade800,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (isSentByMe)
                                        message.read == false
                                            ? const Icon(
                                                Icons.done,
                                                size: 18,
                                              )
                                            : const Icon(
                                                Icons.done_all,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                      Text(
                                        DateFormat('d-MMM yy HH:mm').format(
                                            DateTime.parse(message.sendDate)),
                                        textAlign: isSentByMe
                                            ? TextAlign.right
                                            : TextAlign.left,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
                    // Container(
                    //   height: 55,
                    //   margin: const EdgeInsets.symmetric(horizontal: 4),
                    //   child: IconButton(
                    //     onPressed: () {},
                    //     icon: const Icon(
                    //       Icons.camera_alt,
                    //     ),
                    //   ),
                    // ),
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
                                      message:
                                          MessageModel.fromMap(data.payload),
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
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: IconButton(
                          onPressed: sendChat,
                          icon: const Icon(
                            Icons.send,
                            color: Colors.green,
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
      ),
    );
  }
}
