import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo_app_riverpod/model/todo.dart';

part 'todo_state.freezed.dart';
part 'todo_state.g.dart';

@freezed
class TodosState with _$TodosState {
  const factory TodosState({
    @Default(false) bool isLoading,
    @Default(<Todo>[]) List<Todo> todos,
  }) = _TodosState;

  // {} ではなく =>（アロー）を使ってください
  factory TodosState.fromJson(Map<String, dynamic> json) =>
      _$TodosStateFromJson(json);
}
