// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_riverpod/repositories/auth_repository.dart';
import 'package:todo_app_riverpod/view/signin_page.dart';
import 'package:todo_app_riverpod/view/signup_page.dart';
import 'package:todo_app_riverpod/view_model/controller/auth_controller.dart';
import 'package:todo_app_riverpod/view_model/controller/time_limit_controller.dart';

import 'package:todo_app_riverpod/view_model/controller/todo_list_controller.dart';
import 'package:todo_app_riverpod/model/todo.dart';
import 'package:todo_app_riverpod/view/theme_selection_page.dart';

class Const {
  static const routeNameUpsertTodo = 'upsert-todo';
}

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoListFilter = ref.watch(todoListFilterProvider.state);
    final isDoneFilter = todoListFilter.state == TodoListFilter.isDone;

    return Scaffold(
      appBar: AppBar(
        title: Text('TODO一覧'),
        actions: [
          // チェックしたアイテムの絞り込み
          IconButton(
              onPressed: () => todoListFilter.state =
                  isDoneFilter ? TodoListFilter.all : TodoListFilter.isDone,
              icon: Icon(
                isDoneFilter ? Icons.check_circle : Icons.check_circle_outline,
              ))
        ],
      ),
      drawer: Drawer(
        child: _drawerList(context, ref),
      ),
      body: _buildList(ref),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,

        // アイテム登録ダイアログを表示
        onPressed: () => AddTodoDialog.show(context, Todo.empty()),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}

Widget _drawerList(context, WidgetRef ref) {
  String _infoText = '';
  final authControllerState = ref.watch(authControllerProvider);
  final user = ref.read(authRepositoryProvider).getCurrentUser();
  return ListView(
    children: <Widget>[
      DrawerHeader(
        child: Text(
          authControllerState!.displayName ?? '',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      ListTile(
        title: Text('テーマ設定'),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ThemeSelectionPage()));
        },
      ),
      ListTile(
        title: Text('新規登録'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUpPage(),
            ),
          );
        },
      ),
      user == null
          ? ListTile(
              title: Text('ログイン'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              },
            )
          : SizedBox(),
      ListTile(
        title: Text('ログアウト'),
        onTap: () async {
          try {
            await ref.read(authControllerProvider.notifier).signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignInPage(),
              ),
            );
            _infoText = 'ログアウトしました';
            final snackBar = SnackBar(
                content: Text(
              _infoText,
              textAlign: TextAlign.center,
            ));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } catch (e) {
            e.toString();
          }
        },
      ),
      ListTile(
        title: Text(
          'アカウントの削除',
          style: TextStyle(color: Colors.red),
        ),
        onTap: () {},
      ),
    ],
  );
}

Widget _buildList(WidgetRef ref) {
  final todoListState = ref.watch(todoListProvider);
  final filteredTodoList = ref.watch(filteredTodoListProvider);
  return todoListState.when(
    data: (items) => items.isEmpty
        ? Center(
            child: Text(
              '全てのタスクが完了しました',
              style: TextStyle(fontSize: 20.0),
            ),
          )
        : ListView.builder(
            itemCount: filteredTodoList.length,
            itemBuilder: (BuildContext context, int index) {
              final todo = filteredTodoList[index];
              return _dismissible(context, ref, todo);
            }),
    loading: () => Center(child: CircularProgressIndicator()),
    error: (error, stackTrace) => Text(error.toString()),
  );
}

Widget _dismissible(BuildContext context, WidgetRef ref, Todo todo) {
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
      ref.read(todoListProvider.notifier).deleteTodo(todoId: todo.id!);
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
          ref
              .read(todoListProvider.notifier)
              .updateTodo(updatedTodo: todo.copyWith(isDone: !todo.isDone));
        },
        checkColor: Colors.black,
        activeColor: Colors.white,
      ),
      title: todo.isDone == true
          ? Opacity(
              opacity: 0.3,
              child: Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  decoration: todo.isDone == true
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            )
          : Opacity(
              opacity: 1.0,
              child: Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  decoration: todo.isDone == true
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
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

class AddTodoDialog extends HookConsumerWidget {
  static void show(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AddTodoDialog(todo: todo),
    );
  }

  final Todo todo;

  const AddTodoDialog({Key? key, required this.todo}) : super(key: key);
  bool get isUpdating => todo.id != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useTextEditingController(text: todo.title);
    final limitTime = ref.watch(todoLimitProvider);
    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              decoration: InputDecoration(hintText: 'Item Name'),
            ),
            SizedBox(
              height: 18.0,
            ),
            Row(
              children: [
                SizedBox(
                  width: 200,
                  child: limitTime.limit != null
                      ? Text(DateFormat('yyyy年MM月dd日').format(limitTime.limit!))
                      : Text(
                          '目標達成日を設定する',
                          style: TextStyle(color: Colors.grey),
                        ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    ref.read(todoLimitProvider.notifier).selectDate(context);
                  },
                  child: Text('日付選択'),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    ref.read(todoListProvider.notifier).createTodo(
                        title: textController.text.trim(),
                        limit: limitTime.limit);
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                    final snackBar = SnackBar(
                        backgroundColor: Colors.red[300],
                        content: Text(
                          'Todoを入力して下さい',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text('Add'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
