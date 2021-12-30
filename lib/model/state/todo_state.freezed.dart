// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'todo_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TodosState _$TodosStateFromJson(Map<String, dynamic> json) {
  return _TodosState.fromJson(json);
}

/// @nodoc
class _$TodosStateTearOff {
  const _$TodosStateTearOff();

  _TodosState call(
      {bool isLoading = false, List<Todo> todos = const <Todo>[]}) {
    return _TodosState(
      isLoading: isLoading,
      todos: todos,
    );
  }

  TodosState fromJson(Map<String, Object?> json) {
    return TodosState.fromJson(json);
  }
}

/// @nodoc
const $TodosState = _$TodosStateTearOff();

/// @nodoc
mixin _$TodosState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<Todo> get todos => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TodosStateCopyWith<TodosState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodosStateCopyWith<$Res> {
  factory $TodosStateCopyWith(
          TodosState value, $Res Function(TodosState) then) =
      _$TodosStateCopyWithImpl<$Res>;
  $Res call({bool isLoading, List<Todo> todos});
}

/// @nodoc
class _$TodosStateCopyWithImpl<$Res> implements $TodosStateCopyWith<$Res> {
  _$TodosStateCopyWithImpl(this._value, this._then);

  final TodosState _value;
  // ignore: unused_field
  final $Res Function(TodosState) _then;

  @override
  $Res call({
    Object? isLoading = freezed,
    Object? todos = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      todos: todos == freezed
          ? _value.todos
          : todos // ignore: cast_nullable_to_non_nullable
              as List<Todo>,
    ));
  }
}

/// @nodoc
abstract class _$TodosStateCopyWith<$Res> implements $TodosStateCopyWith<$Res> {
  factory _$TodosStateCopyWith(
          _TodosState value, $Res Function(_TodosState) then) =
      __$TodosStateCopyWithImpl<$Res>;
  @override
  $Res call({bool isLoading, List<Todo> todos});
}

/// @nodoc
class __$TodosStateCopyWithImpl<$Res> extends _$TodosStateCopyWithImpl<$Res>
    implements _$TodosStateCopyWith<$Res> {
  __$TodosStateCopyWithImpl(
      _TodosState _value, $Res Function(_TodosState) _then)
      : super(_value, (v) => _then(v as _TodosState));

  @override
  _TodosState get _value => super._value as _TodosState;

  @override
  $Res call({
    Object? isLoading = freezed,
    Object? todos = freezed,
  }) {
    return _then(_TodosState(
      isLoading: isLoading == freezed
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      todos: todos == freezed
          ? _value.todos
          : todos // ignore: cast_nullable_to_non_nullable
              as List<Todo>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TodosState implements _TodosState {
  const _$_TodosState({this.isLoading = false, this.todos = const <Todo>[]});

  factory _$_TodosState.fromJson(Map<String, dynamic> json) =>
      _$$_TodosStateFromJson(json);

  @JsonKey()
  @override
  final bool isLoading;
  @JsonKey()
  @override
  final List<Todo> todos;

  @override
  String toString() {
    return 'TodosState(isLoading: $isLoading, todos: $todos)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TodosState &&
            const DeepCollectionEquality().equals(other.isLoading, isLoading) &&
            const DeepCollectionEquality().equals(other.todos, todos));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isLoading),
      const DeepCollectionEquality().hash(todos));

  @JsonKey(ignore: true)
  @override
  _$TodosStateCopyWith<_TodosState> get copyWith =>
      __$TodosStateCopyWithImpl<_TodosState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TodosStateToJson(this);
  }
}

abstract class _TodosState implements TodosState {
  const factory _TodosState({bool isLoading, List<Todo> todos}) = _$_TodosState;

  factory _TodosState.fromJson(Map<String, dynamic> json) =
      _$_TodosState.fromJson;

  @override
  bool get isLoading;
  @override
  List<Todo> get todos;
  @override
  @JsonKey(ignore: true)
  _$TodosStateCopyWith<_TodosState> get copyWith =>
      throw _privateConstructorUsedError;
}
