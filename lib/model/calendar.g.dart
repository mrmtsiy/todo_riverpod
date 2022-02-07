// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Calendar _$$_CalendarFromJson(Map<String, dynamic> json) => _$_Calendar(
      focusedDay: DateTime.parse(json['focusedDay'] as String),
      selectedDay: json['selectedDay'] == null
          ? null
          : DateTime.parse(json['selectedDay'] as String),
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => Todo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Todo>[],
    );

Map<String, dynamic> _$$_CalendarToJson(_$_Calendar instance) =>
    <String, dynamic>{
      'focusedDay': instance.focusedDay.toIso8601String(),
      'selectedDay': instance.selectedDay?.toIso8601String(),
      'events': instance.events,
    };
