// ignore_for_file: prefer_const_constructors
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_riverpod/model/todo.dart';

part 'calendar.freezed.dart';
part 'calendar.g.dart';

@freezed
abstract class Calendar implements _$Calendar {
  const Calendar._();
  const factory Calendar({
    required DateTime focusedDay,
    DateTime? selectedDay,
    @Default(<Todo>[]) List<Todo> events,
  }) = _Calendar;

  factory Calendar.fromJson(Map<String, dynamic> json) =>
      _$CalendarFromJson(json);

  Map<String, dynamic> toFirestore() {
    return {
      'focusedDay': focusedDay,
      'selectedDay': selectedDay,
      'events': events,
    };
  }

  factory Calendar.fromFirestore(Map<String, dynamic> document) {
    return Calendar(
      selectedDay: document['selectedDay'],
      focusedDay: document['focusedDay'],
      events: document['events'],
    );
  }

  Calendar setSelectedDay(DateTime dt) {
    return Calendar(events: events, focusedDay: focusedDay, selectedDay: dt);
  }

  Calendar setSchedulesInMonth(List<Todo> items) {
    return Calendar(
      focusedDay: focusedDay,
      selectedDay: selectedDay,
      events: items,
    );
  }

  List<Todo> schedulesInDay() {
    final limit = DateFormat('yyyy-MM-dd', "ja_JP").format(selectedDay!);
    return events
        .where((event) => event.limit == DateTime.parse(limit))
        .toList();
  }
}
