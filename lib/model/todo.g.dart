// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Todo _$$_TodoFromJson(Map<String, dynamic> json) => _$_Todo(
      title: json['title'] as String,
      dateYM: json['dateYM'] as String?,
      dateYMD: json['dateYMD'] as String?,
      id: json['id'] as String?,
      limit: json['limit'] == null
          ? null
          : DateTime.parse(json['limit'] as String),
      isDone: json['isDone'] as bool? ?? false,
    );

Map<String, dynamic> _$$_TodoToJson(_$_Todo instance) => <String, dynamic>{
      'title': instance.title,
      'dateYM': instance.dateYM,
      'dateYMD': instance.dateYMD,
      'id': instance.id,
      'limit': instance.limit?.toIso8601String(),
      'isDone': instance.isDone,
    };
