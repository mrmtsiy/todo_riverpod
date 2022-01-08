// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThemeSelectionPage()),
          ),
        ),
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
      body: _buildList(ref),
      floatingActionButton: FloatingActionButton(
        // アイテム登録ダイアログを表示
        onPressed: () => AddTodoDialog.show(context, Todo.empty()),
        child: Icon(Icons.add),
      ),
    );
  }
}

Widget _buildList(WidgetRef ref) {
  final todoListState = ref.watch(todoListProvider);
  final filteredTodoList = ref.watch(filteredTodoListProvider);
  return todoListState.when(
    data: (items) => items.isEmpty
        ? Center(
            child: Text(
              'Tap + to add an item',
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
              height: 12.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: isUpdating
                        ? Colors.orange
                        : Theme.of(context).primaryColor),
                onPressed: () {
                  isUpdating
                      ? ref.read(todoListProvider.notifier).updateTodo(
                            updatedTodo: todo.copyWith(
                              title: textController.text.trim(),
                              isDone: todo.isDone,
                            ),
                          )
                      : ref
                          .read(todoListProvider.notifier)
                          .createTodo(title: textController.text.trim());
                  Navigator.of(context).pop();
                },
                child: Text(isUpdating ? 'Update' : 'Add'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
