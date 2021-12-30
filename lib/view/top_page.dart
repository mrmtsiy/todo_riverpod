// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:todo_app_riverpod/view_model/controller/todo_list_controller.dart';
import 'package:todo_app_riverpod/model/todo.dart';
import 'package:todo_app_riverpod/view/theme_selection_page.dart';
import 'package:todo_app_riverpod/view/todo_add_page.dart';

class Const {
  static const routeNameUpsertTodo = 'upsert-todo';
}

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThemeSelectionPage()),
          ),
        ),
        title: Text('TODO一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UpsertTodoView()),
            ),
          ),
        ],
      ),
      body: _buildList(ref),
    );
  }
}

Widget _buildList(WidgetRef ref) {
  final todoState = ref.watch(todoListProvider);
  final List<Todo> _todoList = todoState.todos;
  if (todoState.todos.isNotEmpty) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _todoList.length,
      itemBuilder: (BuildContext context, int index) {
        return _dismissible(_todoList[index], context, ref);
      },
    );
  } else {
    return Center(
      child: Text(
        'タスクがありません',
        style: TextStyle(),
      ),
    );
  }
}

Widget _dismissible(Todo todo, BuildContext context, ref) {
  // ListViewのswipeができるwidget
  return Dismissible(
    // ユニークな値を設定
    key: UniqueKey(),
    confirmDismiss: (direction) async {
      final confirmResult = await _showDeleteConfirmDialog(todo.title, context);
      // Future<bool> で確認結果を返す。False の場合削除されない
      return confirmResult;
    },
    onDismissed: (DismissDirection direction) {
      // viewModelのtodoList要素を削除
      ref.read(todoListProvider.notifier).deleteTodo(todo.id);
      // ToastMessageを表示
      Fluttertoast.showToast(
        msg: '${todo.title}を削除しました',
        backgroundColor: Colors.grey,
      );
    },
    // swipe中ListTileのbackground
    background: Container(
      alignment: Alignment.centerLeft,
      // backgroundが赤/ゴミ箱Icon表示
      color: Colors.red,
      child: const Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
    ),
    child: _todoItem(todo, context, ref),
  );
}

Widget _todoItem(Todo todo, BuildContext context, WidgetRef ref) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
    ),
    child: ListTile(
      trailing: Checkbox(
        value: todo.isDone,
        onChanged: (bool? value) {
          ref.read(todoListProvider.notifier).changeComplete(todo, todo.isDone);
        },
        checkColor: Colors.black,
        activeColor: Colors.white,
      ),
      title: Text(
        todo.title,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      onTap: () => _transitionToNextScreen(context, todo: todo),
    ),
  );
}

Future<void> _transitionToNextScreen(BuildContext context, {Todo? todo}) async {
  final result = await Navigator.pushNamed(context, Const.routeNameUpsertTodo,
      arguments: todo);

  if (result != null) {
    // ToastMessageを表示
    Fluttertoast.showToast(
      msg: result.toString(),
      backgroundColor: Colors.grey,
    );
  }
}

Future<bool> _showDeleteConfirmDialog(
    String title, BuildContext context) async {
  final result = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('削除'),
        content: Text('「$title」を削除しますか？'),
        actions: [
          FloatingActionButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('cancel'),
          ),
          FloatingActionButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
  return result;
}
