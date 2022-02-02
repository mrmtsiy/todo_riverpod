// ignore_for_file: prefer_const_constructors

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/model/todo.dart';
import 'package:todo_app_riverpod/repositories/todo_repository.dart';
import 'package:todo_app_riverpod/utils/general_providers.dart';

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
  (ref) {
    final user = ref.watch(firebaseAuthProvider).currentUser;
    return TodoListController(ref.read, user?.uid);
  },
);

class TodoListController extends StateNotifier<AsyncValue<List<Todo>>> {
  TodoListController(this._read, this._userId) : super(AsyncValue.loading()) {
    if (_userId != null) {
      retrieveItems();
    }
  }

  // ignore: unused_field
  final Reader _read;
  final String? _userId;

  Future<void> retrieveItems({bool isRefreshing = false}) async {
    if (isRefreshing) state = AsyncValue.loading();
    final todos =
        await _read(todoRepositoryProvider).retrieveTodos(userId: _userId!);
    if (mounted) {
      state = AsyncValue.data(todos);
    }
  }

  Future<void> createTodo(
      {required String title, bool isDone = false, DateTime? limit}) async {
    final todo = Todo(title: title, isDone: isDone, limit: limit);
    final todoId = await _read(todoRepositoryProvider)
        .createTodo(userId: _userId!, todo: todo);
    state.whenData(
      (todos) => state = AsyncValue.data(
        todos..add(todo.copyWith(id: todoId)),
      ),
    );
  }

  Future<void> updateTodo({required Todo updatedTodo}) async {
    await _read(todoRepositoryProvider)
        .updateTodo(userId: _userId!, todo: updatedTodo);
    state.whenData((todos) {
      state = AsyncValue.data([
        for (final todo in todos)
          if (todo.id == updatedTodo.id) updatedTodo else todo
      ]);
    });
  }

  Future<void> deleteTodo({required String todoId}) async {
    await _read(todoRepositoryProvider)
        .deleteTodo(userId: _userId!, todoId: todoId);
    state.whenData(
      (todos) => state = AsyncValue.data(
        todos..removeWhere((todo) => todo.id == todoId),
      ),
    );
  }
}
