// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'message_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MessageState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T value) success,
    required TResult Function() loading,
    required TResult Function() noData,
    required TResult Function(String? message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(T value)? success,
    TResult? Function()? loading,
    TResult? Function()? noData,
    TResult? Function(String? message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T value)? success,
    TResult Function()? loading,
    TResult Function()? noData,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial<T> value) initial,
    required TResult Function(Success<T> value) success,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(NoDataFound<T> value) noData,
    required TResult Function(ErrorDetails<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial<T> value)? initial,
    TResult? Function(Success<T> value)? success,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(NoDataFound<T> value)? noData,
    TResult? Function(ErrorDetails<T> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial<T> value)? initial,
    TResult Function(Success<T> value)? success,
    TResult Function(Loading<T> value)? loading,
    TResult Function(NoDataFound<T> value)? noData,
    TResult Function(ErrorDetails<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageStateCopyWith<T, $Res> {
  factory $MessageStateCopyWith(
          MessageState<T> value, $Res Function(MessageState<T>) then) =
      _$MessageStateCopyWithImpl<T, $Res, MessageState<T>>;
}

/// @nodoc
class _$MessageStateCopyWithImpl<T, $Res, $Val extends MessageState<T>>
    implements $MessageStateCopyWith<T, $Res> {
  _$MessageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialCopyWith<T, $Res> {
  factory _$$InitialCopyWith(
          _$Initial<T> value, $Res Function(_$Initial<T>) then) =
      __$$InitialCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$InitialCopyWithImpl<T, $Res>
    extends _$MessageStateCopyWithImpl<T, $Res, _$Initial<T>>
    implements _$$InitialCopyWith<T, $Res> {
  __$$InitialCopyWithImpl(
      _$Initial<T> _value, $Res Function(_$Initial<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$Initial<T> implements Initial<T> {
  const _$Initial();

  @override
  String toString() {
    return 'MessageState<$T>.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Initial<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T value) success,
    required TResult Function() loading,
    required TResult Function() noData,
    required TResult Function(String? message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(T value)? success,
    TResult? Function()? loading,
    TResult? Function()? noData,
    TResult? Function(String? message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T value)? success,
    TResult Function()? loading,
    TResult Function()? noData,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial<T> value) initial,
    required TResult Function(Success<T> value) success,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(NoDataFound<T> value) noData,
    required TResult Function(ErrorDetails<T> value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial<T> value)? initial,
    TResult? Function(Success<T> value)? success,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(NoDataFound<T> value)? noData,
    TResult? Function(ErrorDetails<T> value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial<T> value)? initial,
    TResult Function(Success<T> value)? success,
    TResult Function(Loading<T> value)? loading,
    TResult Function(NoDataFound<T> value)? noData,
    TResult Function(ErrorDetails<T> value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class Initial<T> implements MessageState<T> {
  const factory Initial() = _$Initial<T>;
}

/// @nodoc
abstract class _$$SuccessCopyWith<T, $Res> {
  factory _$$SuccessCopyWith(
          _$Success<T> value, $Res Function(_$Success<T>) then) =
      __$$SuccessCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T value});
}

/// @nodoc
class __$$SuccessCopyWithImpl<T, $Res>
    extends _$MessageStateCopyWithImpl<T, $Res, _$Success<T>>
    implements _$$SuccessCopyWith<T, $Res> {
  __$$SuccessCopyWithImpl(
      _$Success<T> _value, $Res Function(_$Success<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$Success<T>(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$Success<T> implements Success<T> {
  const _$Success(this.value);

  @override
  final T value;

  @override
  String toString() {
    return 'MessageState<$T>.success(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Success<T> &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessCopyWith<T, _$Success<T>> get copyWith =>
      __$$SuccessCopyWithImpl<T, _$Success<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T value) success,
    required TResult Function() loading,
    required TResult Function() noData,
    required TResult Function(String? message) error,
  }) {
    return success(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(T value)? success,
    TResult? Function()? loading,
    TResult? Function()? noData,
    TResult? Function(String? message)? error,
  }) {
    return success?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T value)? success,
    TResult Function()? loading,
    TResult Function()? noData,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial<T> value) initial,
    required TResult Function(Success<T> value) success,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(NoDataFound<T> value) noData,
    required TResult Function(ErrorDetails<T> value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial<T> value)? initial,
    TResult? Function(Success<T> value)? success,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(NoDataFound<T> value)? noData,
    TResult? Function(ErrorDetails<T> value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial<T> value)? initial,
    TResult Function(Success<T> value)? success,
    TResult Function(Loading<T> value)? loading,
    TResult Function(NoDataFound<T> value)? noData,
    TResult Function(ErrorDetails<T> value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class Success<T> implements MessageState<T> {
  const factory Success(final T value) = _$Success<T>;

  T get value;
  @JsonKey(ignore: true)
  _$$SuccessCopyWith<T, _$Success<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadingCopyWith<T, $Res> {
  factory _$$LoadingCopyWith(
          _$Loading<T> value, $Res Function(_$Loading<T>) then) =
      __$$LoadingCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$LoadingCopyWithImpl<T, $Res>
    extends _$MessageStateCopyWithImpl<T, $Res, _$Loading<T>>
    implements _$$LoadingCopyWith<T, $Res> {
  __$$LoadingCopyWithImpl(
      _$Loading<T> _value, $Res Function(_$Loading<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$Loading<T> implements Loading<T> {
  const _$Loading();

  @override
  String toString() {
    return 'MessageState<$T>.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Loading<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T value) success,
    required TResult Function() loading,
    required TResult Function() noData,
    required TResult Function(String? message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(T value)? success,
    TResult? Function()? loading,
    TResult? Function()? noData,
    TResult? Function(String? message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T value)? success,
    TResult Function()? loading,
    TResult Function()? noData,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial<T> value) initial,
    required TResult Function(Success<T> value) success,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(NoDataFound<T> value) noData,
    required TResult Function(ErrorDetails<T> value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial<T> value)? initial,
    TResult? Function(Success<T> value)? success,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(NoDataFound<T> value)? noData,
    TResult? Function(ErrorDetails<T> value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial<T> value)? initial,
    TResult Function(Success<T> value)? success,
    TResult Function(Loading<T> value)? loading,
    TResult Function(NoDataFound<T> value)? noData,
    TResult Function(ErrorDetails<T> value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading<T> implements MessageState<T> {
  const factory Loading() = _$Loading<T>;
}

/// @nodoc
abstract class _$$NoDataFoundCopyWith<T, $Res> {
  factory _$$NoDataFoundCopyWith(
          _$NoDataFound<T> value, $Res Function(_$NoDataFound<T>) then) =
      __$$NoDataFoundCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$NoDataFoundCopyWithImpl<T, $Res>
    extends _$MessageStateCopyWithImpl<T, $Res, _$NoDataFound<T>>
    implements _$$NoDataFoundCopyWith<T, $Res> {
  __$$NoDataFoundCopyWithImpl(
      _$NoDataFound<T> _value, $Res Function(_$NoDataFound<T>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$NoDataFound<T> implements NoDataFound<T> {
  const _$NoDataFound();

  @override
  String toString() {
    return 'MessageState<$T>.noData()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NoDataFound<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T value) success,
    required TResult Function() loading,
    required TResult Function() noData,
    required TResult Function(String? message) error,
  }) {
    return noData();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(T value)? success,
    TResult? Function()? loading,
    TResult? Function()? noData,
    TResult? Function(String? message)? error,
  }) {
    return noData?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T value)? success,
    TResult Function()? loading,
    TResult Function()? noData,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (noData != null) {
      return noData();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial<T> value) initial,
    required TResult Function(Success<T> value) success,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(NoDataFound<T> value) noData,
    required TResult Function(ErrorDetails<T> value) error,
  }) {
    return noData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial<T> value)? initial,
    TResult? Function(Success<T> value)? success,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(NoDataFound<T> value)? noData,
    TResult? Function(ErrorDetails<T> value)? error,
  }) {
    return noData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial<T> value)? initial,
    TResult Function(Success<T> value)? success,
    TResult Function(Loading<T> value)? loading,
    TResult Function(NoDataFound<T> value)? noData,
    TResult Function(ErrorDetails<T> value)? error,
    required TResult orElse(),
  }) {
    if (noData != null) {
      return noData(this);
    }
    return orElse();
  }
}

abstract class NoDataFound<T> implements MessageState<T> {
  const factory NoDataFound() = _$NoDataFound<T>;
}

/// @nodoc
abstract class _$$ErrorDetailsCopyWith<T, $Res> {
  factory _$$ErrorDetailsCopyWith(
          _$ErrorDetails<T> value, $Res Function(_$ErrorDetails<T>) then) =
      __$$ErrorDetailsCopyWithImpl<T, $Res>;
  @useResult
  $Res call({String? message});
}

/// @nodoc
class __$$ErrorDetailsCopyWithImpl<T, $Res>
    extends _$MessageStateCopyWithImpl<T, $Res, _$ErrorDetails<T>>
    implements _$$ErrorDetailsCopyWith<T, $Res> {
  __$$ErrorDetailsCopyWithImpl(
      _$ErrorDetails<T> _value, $Res Function(_$ErrorDetails<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$ErrorDetails<T>(
      freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ErrorDetails<T> implements ErrorDetails<T> {
  const _$ErrorDetails([this.message]);

  @override
  final String? message;

  @override
  String toString() {
    return 'MessageState<$T>.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorDetails<T> &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorDetailsCopyWith<T, _$ErrorDetails<T>> get copyWith =>
      __$$ErrorDetailsCopyWithImpl<T, _$ErrorDetails<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T value) success,
    required TResult Function() loading,
    required TResult Function() noData,
    required TResult Function(String? message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(T value)? success,
    TResult? Function()? loading,
    TResult? Function()? noData,
    TResult? Function(String? message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T value)? success,
    TResult Function()? loading,
    TResult Function()? noData,
    TResult Function(String? message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial<T> value) initial,
    required TResult Function(Success<T> value) success,
    required TResult Function(Loading<T> value) loading,
    required TResult Function(NoDataFound<T> value) noData,
    required TResult Function(ErrorDetails<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial<T> value)? initial,
    TResult? Function(Success<T> value)? success,
    TResult? Function(Loading<T> value)? loading,
    TResult? Function(NoDataFound<T> value)? noData,
    TResult? Function(ErrorDetails<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial<T> value)? initial,
    TResult Function(Success<T> value)? success,
    TResult Function(Loading<T> value)? loading,
    TResult Function(NoDataFound<T> value)? noData,
    TResult Function(ErrorDetails<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ErrorDetails<T> implements MessageState<T> {
  const factory ErrorDetails([final String? message]) = _$ErrorDetails<T>;

  String? get message;
  @JsonKey(ignore: true)
  _$$ErrorDetailsCopyWith<T, _$ErrorDetails<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
