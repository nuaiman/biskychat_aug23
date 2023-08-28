import 'package:biskychat_aug23/features/auth/controllers/auth_controller.dart';
import 'package:biskychat_aug23/features/chats/controllers/chats_controller.dart';
import 'package:biskychat_aug23/features/chats/views/messaging_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatsView extends ConsumerWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(chatsControllerProvider.notifier).getAllChats(
              ref: ref,
              currentUid: currentUser.uid,
              currentUser: currentUser,
            ),
        child: ListView.builder(
          itemCount: ref.watch(chatsControllerProvider).length,
          itemBuilder: (context, index) {
            final chat = ref.watch(chatsControllerProvider)[index];
            return ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MessagingView(
                    currentUser: currentUser,
                    otherUser: chat.otherUser,
                  ),
                ));
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(chat.otherUser.imageUrl),
              ),
              title: Text(chat.otherUser.name),
              subtitle: Text(chat.messages.last.text),
            );
          },
        ),
      ),
    );
  }
}
