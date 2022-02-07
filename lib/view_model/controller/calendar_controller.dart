import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app_riverpod/model/calendar.dart';
import 'package:todo_app_riverpod/model/todo.dart';
import 'package:todo_app_riverpod/utils/error_message.dart';
import 'package:todo_app_riverpod/utils/general_providers.dart';

final calendarProvider =
    StateNotifierProvider.autoDispose<CalendarController, Calendar>(
        (ref) => CalendarController(ref.read));

CalendarFormat? _calendarFormat;

class CalendarController extends StateNotifier<Calendar> {
  CalendarController(this._read)
      : super(Calendar(
            events: [],
            selectedDay: DateTime.now(),
            focusedDay: DateTime.now()));

  final Reader _read;

  Future<void> selectDay(DateTime selectedDay) async {
    state = state.copyWith(selectedDay: selectedDay);
  }

  Future<void> onFormatChange(format) async {
    if (_calendarFormat != format) {
      _calendarFormat = format;
    }
  }

  Future<void> onPageChange(focusedDay) async {
    state = state.copyWith(focusedDay: focusedDay);
  }

  Future<AppError?> syncSchedules(DateTime dt) async {
    final dateYM = DateFormat('yyyy-MM-D', "ja_JP").format(dt);
    final loginId = _read(firebaseAuthProvider).currentUser!.uid;

    state = state.setSchedulesInMonth([]);

    try {
      final ref = await FirebaseFirestore.instance
          .collection('users')
          .doc(loginId)
          .collection('todosList')
          // .where('dateYM', isEqualTo: dateYM)
          .get();

      final schedules =
          ref.docs.map((snap) => Todo.fromJson(snap.data())).toList();

      state = state.setSchedulesInMonth(schedules);
    } catch (e) {
      return AppError("エラーが発生しました");
    }
  }
}
