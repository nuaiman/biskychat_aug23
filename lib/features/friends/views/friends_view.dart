import 'package:biskychat_aug23/features/auth/controllers/auth_controller.dart';
import 'package:biskychat_aug23/features/chats/views/messaging_view.dart';
import 'package:biskychat_aug23/features/friends/controllers/friends_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendsView extends ConsumerWidget {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(friendsControllerProvider.notifier)
            .getAllFriends(currentUserId: currentUser.uid),
        child: ListView.builder(
          itemCount: ref.watch(friendsControllerProvider).length,
          itemBuilder: (context, index) {
            final friend = ref.watch(friendsControllerProvider)[index];
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    List uniqueId = [currentUser.uid, friend.uid];
                    uniqueId.sort();
                    final mKey = '${uniqueId[0]}_${uniqueId[1]}';

                    return MessagingView(
                      currentUser: currentUser,
                      otherUser: friend,
                      mKey: mKey,
                    );
                  }),
                );
              },
              leading: CircleAvatar(
                backgroundImage: NetworkImage(friend.imageUrl),
              ),
              title: Text(friend.name),
              subtitle: Text('+${friend.uid}'),
            );
          },
        ),
      ),
    );
  }
}
