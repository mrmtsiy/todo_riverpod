// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TodosState _$$_TodosStateFromJson(Map<String, dynamic> json) =>
    _$_TodosState(
      isLoading: json['isLoading'] as bool? ?? false,
      todos: (json['todos'] as List<dynamic>?)
              ?.map((e) => Todo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Todo>[],
    );

Map<String, dynamic> _$$_TodosStateToJson(_$_TodosState instance) =>
    <String, dynamic>{
      'isLoading': instance.isLoading,
      'todos': instance.todos,
    };
