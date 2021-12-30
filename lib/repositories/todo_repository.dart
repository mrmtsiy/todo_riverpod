// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:todo_app_riverpod/firebase.dart';
// import 'package:todo_app_riverpod/model/todo.dart';
// import 'package:todo_app_riverpod/utils/firestore_extension.dart';

// abstract class BaseTodoRepository {
//   Future<List<Todo>?> getTodos();
//   Future<String?> createTodo({required String userId, required Todo todo});
//   Future<void> updateTodo({required String userId, required Todo todo});
//   Future<void> deleteTodo({required String userId, required String todoId});
// }

// final todoRepositoryProvider = Provider((ref) => TodoRepository(ref.read));

// class TodoRepository implements BaseTodoRepository {
//   final Reader _read;

//   const TodoRepository(this._read);

//   @override
//   Future<List<Todo>?> getTodos() async {
//     try {
//       final snap =
//           await _read(firebaseFirestoreProvider).userListRef(userId).get();
//       return snap.docs.map((doc) => Todo.fromDocument(doc)).toList();
//     } catch (e) {
//       throw '取得に失敗しました';
//     }
//   }

//   @override
//   Future<String?> createTodo({
//     required String userId,
//     required Todo todo,
//   }) async {
//     try {
//       final docRef = await _read(firebaseFirestoreProvider)
//           .userListRef(userId)
//           .add(todo.toDocument());
//       return docRef.id;
//     } catch (e) {
//       throw 'Todoを作成しました';
//     }
//   }

//   @override
//   Future<void> updateTodo({
//     required String userId,
//     required Todo todo,
//   }) async {
//     try {
//       await _read(firebaseFirestoreProvider)
//           .userListRef(userId)
//           .doc(todo.id)
//           .update(todo.toDocument());
//     } catch (e) {
//       throw 'Todoを変更しました';
//     }
//   }

//   @override
//   Future<void> deleteTodo({
//     required String userId,
//     required String todoId,
//   }) async {
//     try {
//       await _read(firebaseFirestoreProvider)
//           .userListRef(userId)
//           .doc(todoId)
//           .delete();
//     } catch (e) {
//       throw 'Todoを削除しました';
//     }
//   }
// }
