// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/view/complete_todo_page.dart';
import 'package:todo_app_riverpod/view/top_page.dart';

final tabTypeProvider = StateProvider<TabType>((ref) => TabType.todo);
enum TabType {
  todo,
  complete,
}

class RoutePage extends HookConsumerWidget {
  const RoutePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabType = ref.watch(tabTypeProvider.state);
    final _screens = [
      const HomeScreen(),
      const InCompleteScreen(),
    ];
    return Scaffold(
      body: _screens[tabType.state.index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabType.state.index,
        onTap: (int selectIndex) {
          tabType.state = TabType.values[selectIndex];
        },
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'todo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'incomplete',
          ),
        ],
      ),
    );
  }
}
