// ignore_for_file: prefer_const_constructors

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/model/todo.dart';
import 'package:todo_app_riverpod/repositories/todo_repository.dart';

enum TodoListFilter {
  all,
  isDone,
}

//フィルターの現在のState
final todoListFilterProvider =
    StateProvider<TodoListFilter>((_) => TodoListFilter.all);

final filteredTodoListProvider = Provider<List<Todo>>((ref) {
  final todoListFilterState = ref.watch(todoListFilterProvider);
  final todoListState = ref.watch(todoListProvider);
  return todoListState.maybeWhen(
    data: (todos) {
      switch (todoListFilterState) {
        case TodoListFilter.isDone:
          return todos.where((todo) => todo.isDone).toList();
        default:
          return todos;
      }
    },
    orElse: () => [],
  );
});

final todoListProvider =
    StateNotifierProvider<TodoListController, AsyncValue<List<Todo>>>(
  (ref) => TodoListController(ref.read),
);

class TodoListController extends StateNotifier<AsyncValue<List<Todo>>> {
  TodoListController(this._read) : super(AsyncValue.loading()) {
    retrieveItems();
  }

  // ignore: unused_field
  final Reader _read;

  Future<void> retrieveItems({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();
    final todos = await _read(todoRepositoryProvider).retrieveTodos();
    if (mounted) {
      state = AsyncValue.data(todos);
    }
  }

  Future<void> createTodo({required String title, bool isDone = false}) async {
    final todo = Todo(title: title, isDone: isDone);
    final todoId = await _read(todoRepositoryProvider).createTodo(todo: todo);
    state.whenData(
      (todos) => state = AsyncValue.data(
        todos..add(todo.copyWith(id: todoId)),
      ),
    );
  }

  Future<void> updateTodo({required Todo updatedTodo}) async {
    await _read(todoRepositoryProvider).updateTodo(todo: updatedTodo);
    state.whenData((todos) {
      state = AsyncValue.data([
        for (final todo in todos)
          if (todo.id == updatedTodo.id) updatedTodo else todo
      ]);
    });
  }

  Future<void> deleteTodo({required String todoId}) async {
    await _read(todoRepositoryProvider).deleteTodo(todoId: todoId);
    state.whenData(
      (todos) => state = AsyncValue.data(
        todos..removeWhere((todo) => todo.id == todoId),
      ),
    );
  }

  void changeComplete(Todo todo, bool value) {
    // final newTodo = todo.copyWith(
    //   isDone: !todo.isDone,
    // );

    // final todos = state.todos
    //     .map((todo) => todo.id == newTodo.id ? newTodo : todo)
    //     .toList();

    // state = state.copyWith(
    //   todos: todos,
    // );
  }
}
