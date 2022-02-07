// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'calendar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Calendar _$CalendarFromJson(Map<String, dynamic> json) {
  return _Calendar.fromJson(json);
}

/// @nodoc
class _$CalendarTearOff {
  const _$CalendarTearOff();

  _Calendar call(
      {required DateTime focusedDay,
      DateTime? selectedDay,
      List<Todo> events = const <Todo>[]}) {
    return _Calendar(
      focusedDay: focusedDay,
      selectedDay: selectedDay,
      events: events,
    );
  }

  Calendar fromJson(Map<String, Object?> json) {
    return Calendar.fromJson(json);
  }
}

/// @nodoc
const $Calendar = _$CalendarTearOff();

/// @nodoc
mixin _$Calendar {
  DateTime get focusedDay => throw _privateConstructorUsedError;
  DateTime? get selectedDay => throw _privateConstructorUsedError;
  List<Todo> get events => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CalendarCopyWith<Calendar> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarCopyWith<$Res> {
  factory $CalendarCopyWith(Calendar value, $Res Function(Calendar) then) =
      _$CalendarCopyWithImpl<$Res>;
  $Res call({DateTime focusedDay, DateTime? selectedDay, List<Todo> events});
}

/// @nodoc
class _$CalendarCopyWithImpl<$Res> implements $CalendarCopyWith<$Res> {
  _$CalendarCopyWithImpl(this._value, this._then);

  final Calendar _value;
  // ignore: unused_field
  final $Res Function(Calendar) _then;

  @override
  $Res call({
    Object? focusedDay = freezed,
    Object? selectedDay = freezed,
    Object? events = freezed,
  }) {
    return _then(_value.copyWith(
      focusedDay: focusedDay == freezed
          ? _value.focusedDay
          : focusedDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedDay: selectedDay == freezed
          ? _value.selectedDay
          : selectedDay // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      events: events == freezed
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<Todo>,
    ));
  }
}

/// @nodoc
abstract class _$CalendarCopyWith<$Res> implements $CalendarCopyWith<$Res> {
  factory _$CalendarCopyWith(_Calendar value, $Res Function(_Calendar) then) =
      __$CalendarCopyWithImpl<$Res>;
  @override
  $Res call({DateTime focusedDay, DateTime? selectedDay, List<Todo> events});
}

/// @nodoc
class __$CalendarCopyWithImpl<$Res> extends _$CalendarCopyWithImpl<$Res>
    implements _$CalendarCopyWith<$Res> {
  __$CalendarCopyWithImpl(_Calendar _value, $Res Function(_Calendar) _then)
      : super(_value, (v) => _then(v as _Calendar));

  @override
  _Calendar get _value => super._value as _Calendar;

  @override
  $Res call({
    Object? focusedDay = freezed,
    Object? selectedDay = freezed,
    Object? events = freezed,
  }) {
    return _then(_Calendar(
      focusedDay: focusedDay == freezed
          ? _value.focusedDay
          : focusedDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedDay: selectedDay == freezed
          ? _value.selectedDay
          : selectedDay // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      events: events == freezed
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<Todo>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Calendar extends _Calendar {
  const _$_Calendar(
      {required this.focusedDay,
      this.selectedDay,
      this.events = const <Todo>[]})
      : super._();

  factory _$_Calendar.fromJson(Map<String, dynamic> json) =>
      _$$_CalendarFromJson(json);

  @override
  final DateTime focusedDay;
  @override
  final DateTime? selectedDay;
  @JsonKey()
  @override
  final List<Todo> events;

  @override
  String toString() {
    return 'Calendar(focusedDay: $focusedDay, selectedDay: $selectedDay, events: $events)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Calendar &&
            const DeepCollectionEquality()
                .equals(other.focusedDay, focusedDay) &&
            const DeepCollectionEquality()
                .equals(other.selectedDay, selectedDay) &&
            const DeepCollectionEquality().equals(other.events, events));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(focusedDay),
      const DeepCollectionEquality().hash(selectedDay),
      const DeepCollectionEquality().hash(events));

  @JsonKey(ignore: true)
  @override
  _$CalendarCopyWith<_Calendar> get copyWith =>
      __$CalendarCopyWithImpl<_Calendar>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CalendarToJson(this);
  }
}

abstract class _Calendar extends Calendar {
  const factory _Calendar(
      {required DateTime focusedDay,
      DateTime? selectedDay,
      List<Todo> events}) = _$_Calendar;
  const _Calendar._() : super._();

  factory _Calendar.fromJson(Map<String, dynamic> json) = _$_Calendar.fromJson;

  @override
  DateTime get focusedDay;
  @override
  DateTime? get selectedDay;
  @override
  List<Todo> get events;
  @override
  @JsonKey(ignore: true)
  _$CalendarCopyWith<_Calendar> get copyWith =>
      throw _privateConstructorUsedError;
}
