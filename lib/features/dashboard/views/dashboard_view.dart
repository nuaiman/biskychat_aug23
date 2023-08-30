import 'package:biskychat_aug23/features/auth/controllers/auth_controller.dart';
import 'package:biskychat_aug23/features/chats/controllers/chats_controller.dart';
import 'package:biskychat_aug23/features/fcm/controllers/fcm_controller.dart';
import 'package:biskychat_aug23/features/friends/controllers/friends_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';
import '../../chats/views/chats_view.dart';
import '../../friends/views/friends_view.dart';
import '../../settings/views/settings_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  late UserModel currentUser;
  @override
  void initState() {
    currentUser = ref.read(authControllerProvider);
    ref
        .read(friendsControllerProvider.notifier)
        .getAllFriends(currentUserId: currentUser.uid);
    ref
        .read(chatsControllerProvider.notifier)
        .getAllChats(ref: ref, currentUser: currentUser);
    ref
        .read(fcmControllerProvider.notifier)
        .createFcmToken(ref, currentUser.uid);
    super.initState();
  }

  final _views = const [
    ChatsView(),
    FriendsView(),
    SettingsView(),
  ];

  int _currentIndex = 0;

  void _onViewChnaged(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_currentIndex],
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (value) => _onViewChnaged(value),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
                _currentIndex == 0 ? Icons.message : Icons.message_outlined),
          ),
          BottomNavigationBarItem(
            icon:
                Icon(_currentIndex == 1 ? Icons.people : Icons.people_outlined),
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _currentIndex == 2 ? Icons.settings : Icons.settings_outlined),
          ),
        ],
      ),
    );
  }
}
