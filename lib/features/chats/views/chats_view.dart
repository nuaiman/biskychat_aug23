import 'package:biskychat_aug23/features/auth/controllers/auth_controller.dart';
import 'package:biskychat_aug23/features/chats/controllers/chats_controller.dart';
import 'package:biskychat_aug23/features/chats/views/messaging_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/error_page.dart';
import '../../../constants/appwrite_constants.dart';
import '../../../models/message_model.dart';

class ChatsView extends ConsumerWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authControllerProvider);

    return ref.watch(getLatestMessageProvider).when(
          data: (data) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Chats'),
              ),
              body: RefreshIndicator(
                onRefresh: () {
                  return ref.read(chatsControllerProvider.notifier).getAllChats(
                        ref: ref,
                        currentUser: currentUser,
                      );
                },
                child: ListView.builder(
                  itemCount: ref.watch(chatsControllerProvider).length,
                  itemBuilder: (context, index) {
                    final chat = ref.watch(chatsControllerProvider)[index];
                    if (data.events.contains(
                        'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.messagesCollection}.documents.*.create')) {
                      ref.read(chatsControllerProvider.notifier).addChatToState(
                            ref: ref,
                            currentUser: currentUser,
                            message: MessageModel.fromMap(data.payload),
                          );
                    }
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            List uniqueId = [
                              currentUser.uid,
                              chat.otherUser.uid
                            ];
                            uniqueId.sort();
                            final mKey = '${uniqueId[0]}_${uniqueId[1]}';

                            return MessagingView(
                              currentUser: currentUser,
                              otherUser: chat.otherUser,
                              mKey: mKey,
                            );
                          },
                        ));
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(chat.otherUser.imageUrl),
                      ),
                      title: Text(chat.otherUser.name),
                      subtitle: Text(chat.messages.first.text),
                    );
                  },
                ),
              ),
            );
          },
          // -------------------------------------------------------
          error: (error, stackTrace) => ErrorPage(error: error.toString()),
          // ----------------------------------------------------------------------
          loading: () => Scaffold(
            appBar: AppBar(
              title: const Text('Chats'),
            ),
            body: RefreshIndicator(
              onRefresh: () =>
                  ref.read(chatsControllerProvider.notifier).getAllChats(
                        ref: ref,
                        currentUser: currentUser,
                      ),
              child: ListView.builder(
                itemCount: ref.watch(chatsControllerProvider).length,
                itemBuilder: (context, index) {
                  final chat = ref.watch(chatsControllerProvider)[index];
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          List uniqueId = [currentUser.uid, chat.otherUser.uid];
                          uniqueId.sort();
                          final mKey = '${uniqueId[0]}_${uniqueId[1]}';

                          return MessagingView(
                            currentUser: currentUser,
                            otherUser: chat.otherUser,
                            mKey: mKey,
                          );
                        },
                      ));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(chat.otherUser.imageUrl),
                    ),
                    title: Text(chat.otherUser.name),
                    subtitle: Text(chat.messages.first.text),
                  );
                },
              ),
            ),
          ),
        );
  }
}
