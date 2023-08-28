import '../../chats/views/chats_view.dart';
import '../../friends/views/friends_view.dart';
import '../../settings/views/settings_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
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
