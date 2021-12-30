// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/view_model/controller/theme_controller.dart';
import 'package:todo_app_riverpod/utils/dark_theme.dart';
import 'package:todo_app_riverpod/utils/light_theme.dart';
import 'package:todo_app_riverpod/utils/page_route.dart';
import 'package:todo_app_riverpod/view/todo_add_page.dart';
import 'package:todo_app_riverpod/view/top_page.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeSelectorProvider);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeMode == ThemeMode.dark ? darkThemeData : lightThemeData,
      darkTheme: themeMode == ThemeMode.light ? lightThemeData : darkThemeData,
      routes: <String, WidgetBuilder>{
        Const.routeNameUpsertTodo: (BuildContext context) => UpsertTodoView(),
      },
      home: RoutePage(),
    );
  }
}
