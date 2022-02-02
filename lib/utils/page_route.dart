// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/view/calendar_page.dart';
import 'package:todo_app_riverpod/view/top_page.dart';
import 'package:todo_app_riverpod/view_model/controller/theme_controller.dart';

final tabTypeProvider = StateProvider<TabType>((ref) => TabType.todo);
enum TabType {
  todo,
  complete,
}

class RoutePage extends HookConsumerWidget {
  const RoutePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeSelectorProvider);
    final tabType = ref.watch(tabTypeProvider.state);
    final _screens = [
      const HomeScreen(),
      const CalendarScreen(),
    ];
    return Scaffold(
      body: _screens[tabType.state.index],
      bottomNavigationBar: themeMode == ThemeMode.dark
          ? CurvedNavigationBar(
              color: Colors.white,
              backgroundColor: Colors.black12,
              index: tabType.state.index,
              animationDuration: Duration(milliseconds: 300),
              animationCurve: Curves.bounceInOut,
              onTap: (int selectIndex) {
                tabType.state = TabType.values[selectIndex];
              },
              items: [
                Icon(
                  Icons.book_outlined,
                  color: Colors.black87,
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                ),
              ],
            )
          : CurvedNavigationBar(
              color: Colors.blue,
              backgroundColor: Colors.white,
              animationDuration: Duration(milliseconds: 300),
              animationCurve: Curves.bounceInOut,
              index: tabType.state.index,
              onTap: (int selectIndex) {
                tabType.state = TabType.values[selectIndex];
              },
              items: [
                Icon(
                  Icons.book_outlined,
                  color: Colors.white,
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                ),
              ],
            ),
    );
  }
}
