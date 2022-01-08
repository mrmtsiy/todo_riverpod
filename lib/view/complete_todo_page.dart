import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app_riverpod/view_model/controller/todo_list_controller.dart';
import 'package:todo_app_riverpod/model/todo.dart';

class InCompleteScreen extends StatelessWidget {
  // const InCompleteScreen({Key? key}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('未完了のTODO'),
  //     ),
  //     body: _BuildList(),
  //   );
  // }
  const InCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('未完了のTODO'),
      ),
      body: Container(),
    );
  }
}

// class _BuildList extends HookConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final todoState = ref.watch(todoListProvider);
//     final List<Todo> _todoList = todoState.todos;

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _todoList.length,
//       itemBuilder: (BuildContext context, int index) {
//         return _todoList[index].isDone == false
//             ? _todoItem(_todoList[index], context, ref)
//             : const SizedBox();
//       },
//     );
//   }
// }

// Widget _todoItem(Todo todo, BuildContext context, WidgetRef ref) {
//   return Container(
//     decoration: const BoxDecoration(
//       border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
//     ),
//     child: ListTile(
//       title: Text(
//         todo.title,
//         style: const TextStyle(
//           fontSize: 16,
//         ),
//       ),
//       onTap: () {},
//     ),
//   );
// }
