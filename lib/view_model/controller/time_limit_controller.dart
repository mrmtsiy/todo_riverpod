import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/model/todo.dart';

final todoLimitProvider =
    StateNotifierProvider.autoDispose<TodoController, Todo>(
        (ref) => TodoController());

class TodoController extends StateNotifier<Todo> {
  TodoController() : super(const Todo(limit: null, title: 'タイトルなし'));

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(Duration(days: 365)));
    // builder: (BuilderContext context, Widget widget){
    //   return widget;
    // }

    if (picked != null) {
      state = state.copyWith(limit: picked);
    }
  }
}
