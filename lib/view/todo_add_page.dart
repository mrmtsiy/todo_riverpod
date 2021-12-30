// ignore_for_file: use_key_in_widget_constructors, unnecessary_null_comparison, must_be_immutable

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/view_model/controller/todo_list_controller.dart';
import 'package:todo_app_riverpod/model/todo.dart';

class UpsertTodoView extends StatelessWidget {
  const UpsertTodoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context)?.settings.arguments as Todo?;
    return Scaffold(
      appBar: AppBar(
        title: Text(todo != null ? 'Todo${'更新'}' : 'Todo${'作成'}'),
      ),
      body: TodoForm(),
    );
  }
}

class TodoForm extends HookConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  String? _title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Todo? todo = ModalRoute.of(context)!.settings.arguments as Todo?;
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              initialValue: todo != null ? todo.title : '',
              maxLength: 20,
              // maxLength以上入力不可

              decoration: const InputDecoration(
                hintText: 'Todoタイトルを入力してください',
                labelText: 'Todoタイトル',
              ),
              validator: (String? title) {
                return title!.isEmpty ? 'Todoタイトルを入力してください' : null;
              },
              onSaved: (String? title) {
                _title = title!;
              },
            ),
            ElevatedButton(
              onPressed: () => _submission(context, todo, ref),
              child: Text('Todoを${todo == null ? '作成' : '更新'}する'),
            ),
          ],
        ),
      ),
    );
  }

  void _submission(BuildContext context, Todo? todo, WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      if (todo != null) {
        // viewModelのtodoListを更新
        ref.read(todoListProvider.notifier).updateTodo(todo.id!, _title!);
      } else {
        // viewModelのtodoListを作成
        ref.read(todoListProvider.notifier).createTodo(_title!);
      }
      // 前の画面に戻る
      Navigator.pop(context, '$_title${todo == null ? 'を作成' : 'に更新'}しました');
    }
  }
}
