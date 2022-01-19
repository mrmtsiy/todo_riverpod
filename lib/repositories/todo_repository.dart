import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/extension/firebase_firestore_extension.dart';
import 'package:todo_app_riverpod/model/todo.dart';
import 'package:todo_app_riverpod/utils/general_providers.dart';

abstract class BaseTodoRepository {
  Future<List<Todo>> retrieveTodos({required String userId});
  Future<String> createTodo({required String userId, required Todo todo});
  Future<void> updateTodo({required String userId, required Todo todo});
  Future<void> deleteTodo({required String userId, required String todoId});
}

final todoRepositoryProvider =
    Provider<TodoRepository>((ref) => TodoRepository(ref.read));

class TodoRepository implements BaseTodoRepository {
  final Reader _read;

  const TodoRepository(this._read);

  @override
  Future<List<Todo>> retrieveTodos({required String userId}) async {
    final snapshot =
        await _read(firebaseFirestoreProvider).userListRef(userId).get();
    return snapshot.docs.map((doc) => Todo.fromDocument(doc)).toList();
  }

  @override
  Future<String> createTodo(
      {required String userId, required Todo todo}) async {
    final docRef = await _read(firebaseFirestoreProvider)
        .userListRef(userId)
        .add(todo.toDocument());
    return docRef.id;
  }

  @override
  Future<void> deleteTodo(
      {required String userId, required String todoId}) async {
    await _read(firebaseFirestoreProvider)
        .userListRef(userId)
        .doc(todoId)
        .delete();
  }

  @override
  Future<void> updateTodo({required String userId, required Todo todo}) async {
    await _read(firebaseFirestoreProvider)
        .userListRef(userId)
        .doc(todo.id)
        .update(todo.toDocument());
  }
}
