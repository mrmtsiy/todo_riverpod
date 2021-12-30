// ignore_for_file: prefer_const_constructors

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/model/state/todo_state.dart';
import 'package:todo_app_riverpod/model/todo.dart';

enum TodoListFilter {
  all,
  obtained,
}

final todoListProvider = StateNotifierProvider<TodoListController, TodosState>(
  (ref) => TodoListController(ref.read),
);

class TodoListController extends StateNotifier<TodosState> {
  TodoListController(this._reader) : super(TodosState());

  // ignore: unused_field
  final Reader _reader;

  final List<Todo> todos = [];

  void createTodo(String title) {
    final id = state.todos.length + 1;
    final newList = [
      ...state.todos,
      Todo(
        title: title,
        id: id,
      )
    ];
    state = state.copyWith(todos: newList);
  }

  void updateTodo(int id, String title) {
    final newList = state.todos
        .map((todo) => todo.id == id ? Todo(title: title, id: id) : todo)
        .toList();
    state = state.copyWith(todos: newList);
  }

  void deleteTodo(int id) {
    final newList = state.todos.where((todo) => todo.id != id).toList();
    state = state.copyWith(todos: newList);
  }

  void changeComplete(Todo todo, bool value) {
    final newTodo = todo.copyWith(
      isDone: !todo.isDone,
    );

    final todos = state.todos
        .map((todo) => todo.id == newTodo.id ? newTodo : todo)
        .toList();

    state = state.copyWith(
      todos: todos,
    );
  }
}
