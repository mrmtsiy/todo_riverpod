// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
abstract class Todo implements _$Todo {
  const Todo._();
  const factory Todo({
    required String title,
    String? dateYM,
    String? dateYMD,
    String? id,
    DateTime? limit,
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

  DateTime? date() {
    // return DateTime.parse(dateYMD!);
    return limit;
  }

  String? dateDisplayText() {
    return DateFormat('MM月dd日', "ja_JP").format(date()!);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "dateYM": dateYM,
      "dateYMD": dateYMD,
      "title": title,
      "isDone": isDone,
      "limit": limit,
    };
  }

  static Todo fromFirestore(Map<String, dynamic> data) {
    return Todo(
        id: data["id"],
        dateYM: data["dateYM"],
        dateYMD: data["dateYMD"],
        title: data["title"],
        limit: data["limit"],
        isDone: data["isDone"]);
  }
}
