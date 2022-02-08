// ignore_for_file: prefer_const_constructors

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app_riverpod/model/todo.dart';
import 'package:todo_app_riverpod/view_model/controller/calendar_controller.dart';

class CalendarScreen extends HookConsumerWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarProvider);
    final calendarAction = ref.read(calendarProvider.notifier);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        calendarAction.syncSchedules(DateTime.now());
      });
      return () {};
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: Text('カレンダー'),
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'ja_JP',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: calendarState.focusedDay,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
            eventLoader:
                EventMaker(schedules: calendarState.events).getLoader(),

            selectedDayPredicate: (day) {
              return isSameDay(calendarState.selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(calendarState.selectedDay, selectedDay)) {
                calendarAction.selectDay(selectedDay);
              }
            },
            onPageChanged: (focusedDay) {
              calendarAction.onPageChange(focusedDay);
              calendarAction.syncSchedules(focusedDay);
            },

            //バッジのUIを数字に変更
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return _buildEventsMarker(date, events);
                }
              },
            ),
          ),
          SizedBox(
            height: 5,
            child: Container(
              color: Colors.grey[300],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: calendarState.schedulesInDay().isEmpty
                ? Center(child: Text('イベントはありません'))
                : ListView.builder(
                    itemCount: calendarState.schedulesInDay().length,
                    itemBuilder: (BuildContext context, int index) {
                      final Todo? schedule =
                          calendarState.schedulesInDay()[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    schedule!.title,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              schedule.isDone == true
                                  ? Container(
                                      child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.greenAccent,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          child: Text(
                                            '達成済み',
                                            style: TextStyle(
                                                color: Colors.greenAccent),
                                          ),
                                        ),
                                      ],
                                    ))
                                  : SizedBox()
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

Widget _buildEventsMarker(DateTime date, List events) {
  return Positioned(
    right: 5,
    bottom: 5,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red[300],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    ),
  );
}

typedef EventLoader = List<dynamic> Function(DateTime day);

class EventMaker {
  final List<Todo> schedules;

  EventMaker({required this.schedules});

  int _getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  EventLoader getLoader() {
    final events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: _getHashCode,
    );

    Map<DateTime, List<Todo>> _eventsList = {
      // DateTime.now(): [Todo(title: 'test'), Todo(title: 'test2')],
    };
    for (var schedule in schedules) {
      if (_eventsList.containsKey(schedule.date())) {
        _eventsList[schedule.date()]!.add(schedule);
      } else {
        _eventsList[schedule.date()!] = [schedule];
      }
    }

    events.addAll(_eventsList);

    return (DateTime day) {
      return events[day] ?? [];
    };
  }
}
