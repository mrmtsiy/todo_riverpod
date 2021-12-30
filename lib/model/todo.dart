// ignore_for_file: prefer_const_constructors
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    required String title,
    int? id,
    @Default(false) bool isDone,
  }) = _Todo;

  factory Todo.empty() => Todo(title: '');
  // {} ではなく =>（アロー）を使ってください
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
