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

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

class CalendarController extends StateNotifier<Calendar> {
  CalendarController(this._read) : super(Calendar(focusedDay: DateTime.now()));

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

  // Stream<List<Todo>?> getEventStream(DateTime? dateTime) {
  //   return _read(firebaseFirestoreProvider)
  //       .collection('users')
  //       .doc(_read(firebaseAuthProvider).currentUser?.uid)
  //       .collection('todosList')
  //       .where('limit', isEqualTo: dateTime)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //           .map(
  //             (document) => Calendar.fromFirestore(
  //               document.data(),
  //             ),
  //           )
  //           .toList() as List<Todo>);
  // }

  Future<AppError?> syncSchedules(DateTime dt) async {
    final dateYM = DateFormat('yyyy-MM', "ja_JP").format(dt);
    final loginId = _read(firebaseAuthProvider).currentUser!.uid;

    state = state.setSchedulesInMonth([])!;

    try {
      final ref = FirebaseFirestore.instance
          .collection('users')
          .doc(loginId)
          .collection('todosList')
          .where('limit', isEqualTo: dateYM);
      final snapshots = await ref.orderBy("limit").get();
      final schedules =
          snapshots.docs.map((snap) => Todo.fromJson(snap.data())).toList();
      state = state.setSchedulesInMonth(schedules)!;
    } catch (e) {
      return AppError("エラーが発生しました");
    }
  }
}
