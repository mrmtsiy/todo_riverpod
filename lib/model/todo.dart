// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
abstract class Todo implements _$Todo {
  const Todo._();
  const factory Todo({
    required String title,
    String? id,
    @Default(false) bool isDone,
  }) = _Todo;

  factory Todo.empty() => Todo(title: '');
  // {} ではなく =>（アロー）を使ってください
  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
// ドキュメントのスナップショットを変換するために利用
  factory Todo.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    // doc.idがitemIDのため、copyWithでIDをモデルにコピーする
    return Todo.fromJson(data).copyWith(id: doc.id);
  }
  // アイテムモデルをMap<String, dynamic>に変換するメソッド
  Map<String, dynamic> toDocument() => toJson()..remove('id');
}
