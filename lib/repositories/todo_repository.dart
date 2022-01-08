import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/model/todo.dart';
import 'package:todo_app_riverpod/utils/general_providers.dart';

abstract class BaseTodoRepository {
  Future<List<Todo>> retrieveTodos();
  Future<String> createTodo({required Todo todo});
  Future<void> updateTodo({required Todo todo});
  Future<void> deleteTodo({required String todoId});
  Future<void> isDoneTodo({required String todoId});
}

final todoRepositoryProvider =
    Provider<TodoRepository>((ref) => TodoRepository(ref.read));

class TodoRepository implements BaseTodoRepository {
  final Reader _read;

  const TodoRepository(this._read);

  @override
  Future<List<Todo>> retrieveTodos() async {
    final snapshot =
        await _read(firebaseFirestoreProvider).collection('todos').get();
    return snapshot.docs.map((doc) => Todo.fromDocument(doc)).toList();
  }

  @override
  Future<String> createTodo({required Todo todo}) async {
    final docRef = await _read(firebaseFirestoreProvider)
        .collection('todos')
        .add(todo.toDocument());
    return docRef.id;
  }

  @override
  Future<void> deleteTodo({required String todoId}) async {
    await _read(firebaseFirestoreProvider)
        .collection('todos')
        .doc(todoId)
        .delete();
  }

  @override
  Future<void> updateTodo({required Todo todo}) async {
    await _read(firebaseFirestoreProvider)
        .collection('todos')
        .doc(todo.id)
        .update(todo.toDocument());
  }

  @override
  Future<void> isDoneTodo({required String todoId}) async {
    await _read(firebaseFirestoreProvider).collection('todos').doc(todoId);
  }
}
