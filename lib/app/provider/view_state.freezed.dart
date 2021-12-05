// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ViewStateTearOff {
  const _$ViewStateTearOff();

  ViewStateData<T> call<T>({T? value}) {
    return ViewStateData<T>(
      value: value,
    );
  }

  ViewStateLoading<T> loading<T>() {
    return ViewStateLoading<T>();
  }

  ViewStateError<T> error<T>(
      {int? statusCode, String? message, String? detail}) {
    return ViewStateError<T>(
      statusCode: statusCode,
      message: message,
      detail: detail,
    );
  }
}

/// @nodoc
const $ViewState = _$ViewStateTearOff();

/// @nodoc
mixin _$ViewState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(T? value) $default, {
    required TResult Function() loading,
    required TResult Function(int? statusCode, String? message, String? detail)
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(T? value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(T? value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(ViewStateData<T> value) $default, {
    required TResult Function(ViewStateLoading<T> value) loading,
    required TResult Function(ViewStateError<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(ViewStateData<T> value)? $default, {
    TResult Function(ViewStateLoading<T> value)? loading,
    TResult Function(ViewStateError<T> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(ViewStateData<T> value)? $default, {
    TResult Function(ViewStateLoading<T> value)? loading,
    TResult Function(ViewStateError<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ViewStateCopyWith<T, $Res> {
  factory $ViewStateCopyWith(
          ViewState<T> value, $Res Function(ViewState<T>) then) =
      _$ViewStateCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$ViewStateCopyWithImpl<T, $Res> implements $ViewStateCopyWith<T, $Res> {
  _$ViewStateCopyWithImpl(this._value, this._then);

  final ViewState<T> _value;
  // ignore: unused_field
  final $Res Function(ViewState<T>) _then;
}

/// @nodoc
abstract class $ViewStateDataCopyWith<T, $Res> {
  factory $ViewStateDataCopyWith(
          ViewStateData<T> value, $Res Function(ViewStateData<T>) then) =
      _$ViewStateDataCopyWithImpl<T, $Res>;
  $Res call({T? value});
}

/// @nodoc
class _$ViewStateDataCopyWithImpl<T, $Res>
    extends _$ViewStateCopyWithImpl<T, $Res>
    implements $ViewStateDataCopyWith<T, $Res> {
  _$ViewStateDataCopyWithImpl(
      ViewStateData<T> _value, $Res Function(ViewStateData<T>) _then)
      : super(_value, (v) => _then(v as ViewStateData<T>));

  @override
  ViewStateData<T> get _value => super._value as ViewStateData<T>;

  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(ViewStateData<T>(
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc

class _$ViewStateData<T> implements ViewStateData<T> {
  const _$ViewStateData({this.value});

  @override
  final T? value;

  @override
  String toString() {
    return 'ViewState<$T>(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ViewStateData<T> &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  @JsonKey(ignore: true)
  @override
  $ViewStateDataCopyWith<T, ViewStateData<T>> get copyWith =>
      _$ViewStateDataCopyWithImpl<T, ViewStateData<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(T? value) $default, {
    required TResult Function() loading,
    required TResult Function(int? statusCode, String? message, String? detail)
        error,
  }) {
    return $default(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(T? value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
  }) {
    return $default?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(T? value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(ViewStateData<T> value) $default, {
    required TResult Function(ViewStateLoading<T> value) loading,
    required TResult Function(ViewStateError<T> value) error,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(ViewStateData<T> value)? $default, {
    TResult Function(ViewStateLoading<T> value)? loading,
    TResult Function(ViewStateError<T> value)? error,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(ViewStateData<T> value)? $default, {
    TResult Function(ViewStateLoading<T> value)? loading,
    TResult Function(ViewStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class ViewStateData<T> implements ViewState<T> {
  const factory ViewStateData({T? value}) = _$ViewStateData<T>;

  T? get value;
  @JsonKey(ignore: true)
  $ViewStateDataCopyWith<T, ViewStateData<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ViewStateLoadingCopyWith<T, $Res> {
  factory $ViewStateLoadingCopyWith(
          ViewStateLoading<T> value, $Res Function(ViewStateLoading<T>) then) =
      _$ViewStateLoadingCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$ViewStateLoadingCopyWithImpl<T, $Res>
    extends _$ViewStateCopyWithImpl<T, $Res>
    implements $ViewStateLoadingCopyWith<T, $Res> {
  _$ViewStateLoadingCopyWithImpl(
      ViewStateLoading<T> _value, $Res Function(ViewStateLoading<T>) _then)
      : super(_value, (v) => _then(v as ViewStateLoading<T>));

  @override
  ViewStateLoading<T> get _value => super._value as ViewStateLoading<T>;
}

/// @nodoc

class _$ViewStateLoading<T> implements ViewStateLoading<T> {
  const _$ViewStateLoading();

  @override
  String toString() {
    return 'ViewState<$T>.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ViewStateLoading<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(T? value) $default, {
    required TResult Function() loading,
    required TResult Function(int? statusCode, String? message, String? detail)
        error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(T? value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(T? value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(ViewStateData<T> value) $default, {
    required TResult Function(ViewStateLoading<T> value) loading,
    required TResult Function(ViewStateError<T> value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(ViewStateData<T> value)? $default, {
    TResult Function(ViewStateLoading<T> value)? loading,
    TResult Function(ViewStateError<T> value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(ViewStateData<T> value)? $default, {
    TResult Function(ViewStateLoading<T> value)? loading,
    TResult Function(ViewStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ViewStateLoading<T> implements ViewState<T> {
  const factory ViewStateLoading() = _$ViewStateLoading<T>;
}

/// @nodoc
abstract class $ViewStateErrorCopyWith<T, $Res> {
  factory $ViewStateErrorCopyWith(
          ViewStateError<T> value, $Res Function(ViewStateError<T>) then) =
      _$ViewStateErrorCopyWithImpl<T, $Res>;
  $Res call({int? statusCode, String? message, String? detail});
}

/// @nodoc
class _$ViewStateErrorCopyWithImpl<T, $Res>
    extends _$ViewStateCopyWithImpl<T, $Res>
    implements $ViewStateErrorCopyWith<T, $Res> {
  _$ViewStateErrorCopyWithImpl(
      ViewStateError<T> _value, $Res Function(ViewStateError<T>) _then)
      : super(_value, (v) => _then(v as ViewStateError<T>));

  @override
  ViewStateError<T> get _value => super._value as ViewStateError<T>;

  @override
  $Res call({
    Object? statusCode = freezed,
    Object? message = freezed,
    Object? detail = freezed,
  }) {
    return _then(ViewStateError<T>(
      statusCode: statusCode == freezed
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      detail: detail == freezed
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ViewStateError<T> implements ViewStateError<T> {
  const _$ViewStateError({this.statusCode, this.message, this.detail});

  @override
  final int? statusCode;
  @override
  final String? message;
  @override
  final String? detail;

  @override
  String toString() {
    return 'ViewState<$T>.error(statusCode: $statusCode, message: $message, detail: $detail)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ViewStateError<T> &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.detail, detail) || other.detail == detail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statusCode, message, detail);

  @JsonKey(ignore: true)
  @override
  $ViewStateErrorCopyWith<T, ViewStateError<T>> get copyWith =>
      _$ViewStateErrorCopyWithImpl<T, ViewStateError<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(T? value) $default, {
    required TResult Function() loading,
    required TResult Function(int? statusCode, String? message, String? detail)
        error,
  }) {
    return error(statusCode, message, detail);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(T? value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
  }) {
    return error?.call(statusCode, message, detail);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(T? value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(statusCode, message, detail);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(ViewStateData<T> value) $default, {
    required TResult Function(ViewStateLoading<T> value) loading,
    required TResult Function(ViewStateError<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(ViewStateData<T> value)? $default, {
    TResult Function(ViewStateLoading<T> value)? loading,
    TResult Function(ViewStateError<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(ViewStateData<T> value)? $default, {
    TResult Function(ViewStateLoading<T> value)? loading,
    TResult Function(ViewStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ViewStateError<T> implements ViewState<T> {
  const factory ViewStateError(
      {int? statusCode, String? message, String? detail}) = _$ViewStateError<T>;

  int? get statusCode;
  String? get message;
  String? get detail;
  @JsonKey(ignore: true)
  $ViewStateErrorCopyWith<T, ViewStateError<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$ListViewStateTearOff {
  const _$ListViewStateTearOff();

  ListViewStateData<T> call<T>({required List<T> value}) {
    return ListViewStateData<T>(
      value: value,
    );
  }

  ListViewStateLoading<T> loading<T>() {
    return ListViewStateLoading<T>();
  }

  ListViewStateError<T> error<T>(
      {int? statusCode, String? message, String? detail}) {
    return ListViewStateError<T>(
      statusCode: statusCode,
      message: message,
      detail: detail,
    );
  }
}

/// @nodoc
const $ListViewState = _$ListViewStateTearOff();

/// @nodoc
mixin _$ListViewState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<T> value) $default, {
    required TResult Function() loading,
    required TResult Function(int? statusCode, String? message, String? detail)
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(ListViewStateData<T> value) $default, {
    required TResult Function(ListViewStateLoading<T> value) loading,
    required TResult Function(ListViewStateError<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(ListViewStateData<T> value)? $default, {
    TResult Function(ListViewStateLoading<T> value)? loading,
    TResult Function(ListViewStateError<T> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(ListViewStateData<T> value)? $default, {
    TResult Function(ListViewStateLoading<T> value)? loading,
    TResult Function(ListViewStateError<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListViewStateCopyWith<T, $Res> {
  factory $ListViewStateCopyWith(
          ListViewState<T> value, $Res Function(ListViewState<T>) then) =
      _$ListViewStateCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$ListViewStateCopyWithImpl<T, $Res>
    implements $ListViewStateCopyWith<T, $Res> {
  _$ListViewStateCopyWithImpl(this._value, this._then);

  final ListViewState<T> _value;
  // ignore: unused_field
  final $Res Function(ListViewState<T>) _then;
}

/// @nodoc
abstract class $ListViewStateDataCopyWith<T, $Res> {
  factory $ListViewStateDataCopyWith(ListViewStateData<T> value,
          $Res Function(ListViewStateData<T>) then) =
      _$ListViewStateDataCopyWithImpl<T, $Res>;
  $Res call({List<T> value});
}

/// @nodoc
class _$ListViewStateDataCopyWithImpl<T, $Res>
    extends _$ListViewStateCopyWithImpl<T, $Res>
    implements $ListViewStateDataCopyWith<T, $Res> {
  _$ListViewStateDataCopyWithImpl(
      ListViewStateData<T> _value, $Res Function(ListViewStateData<T>) _then)
      : super(_value, (v) => _then(v as ListViewStateData<T>));

  @override
  ListViewStateData<T> get _value => super._value as ListViewStateData<T>;

  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(ListViewStateData<T>(
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ));
  }
}

/// @nodoc

class _$ListViewStateData<T> implements ListViewStateData<T> {
  const _$ListViewStateData({required this.value});

  @override
  final List<T> value;

  @override
  String toString() {
    return 'ListViewState<$T>(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ListViewStateData<T> &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  @JsonKey(ignore: true)
  @override
  $ListViewStateDataCopyWith<T, ListViewStateData<T>> get copyWith =>
      _$ListViewStateDataCopyWithImpl<T, ListViewStateData<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<T> value) $default, {
    required TResult Function() loading,
    required TResult Function(int? statusCode, String? message, String? detail)
        error,
  }) {
    return $default(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
  }) {
    return $default?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(ListViewStateData<T> value) $default, {
    required TResult Function(ListViewStateLoading<T> value) loading,
    required TResult Function(ListViewStateError<T> value) error,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(ListViewStateData<T> value)? $default, {
    TResult Function(ListViewStateLoading<T> value)? loading,
    TResult Function(ListViewStateError<T> value)? error,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(ListViewStateData<T> value)? $default, {
    TResult Function(ListViewStateLoading<T> value)? loading,
    TResult Function(ListViewStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class ListViewStateData<T> implements ListViewState<T> {
  const factory ListViewStateData({required List<T> value}) =
      _$ListViewStateData<T>;

  List<T> get value;
  @JsonKey(ignore: true)
  $ListViewStateDataCopyWith<T, ListViewStateData<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListViewStateLoadingCopyWith<T, $Res> {
  factory $ListViewStateLoadingCopyWith(ListViewStateLoading<T> value,
          $Res Function(ListViewStateLoading<T>) then) =
      _$ListViewStateLoadingCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$ListViewStateLoadingCopyWithImpl<T, $Res>
    extends _$ListViewStateCopyWithImpl<T, $Res>
    implements $ListViewStateLoadingCopyWith<T, $Res> {
  _$ListViewStateLoadingCopyWithImpl(ListViewStateLoading<T> _value,
      $Res Function(ListViewStateLoading<T>) _then)
      : super(_value, (v) => _then(v as ListViewStateLoading<T>));

  @override
  ListViewStateLoading<T> get _value => super._value as ListViewStateLoading<T>;
}

/// @nodoc

class _$ListViewStateLoading<T> implements ListViewStateLoading<T> {
  const _$ListViewStateLoading();

  @override
  String toString() {
    return 'ListViewState<$T>.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ListViewStateLoading<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<T> value) $default, {
    required TResult Function() loading,
    required TResult Function(int? statusCode, String? message, String? detail)
        error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(ListViewStateData<T> value) $default, {
    required TResult Function(ListViewStateLoading<T> value) loading,
    required TResult Function(ListViewStateError<T> value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(ListViewStateData<T> value)? $default, {
    TResult Function(ListViewStateLoading<T> value)? loading,
    TResult Function(ListViewStateError<T> value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(ListViewStateData<T> value)? $default, {
    TResult Function(ListViewStateLoading<T> value)? loading,
    TResult Function(ListViewStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ListViewStateLoading<T> implements ListViewState<T> {
  const factory ListViewStateLoading() = _$ListViewStateLoading<T>;
}

/// @nodoc
abstract class $ListViewStateErrorCopyWith<T, $Res> {
  factory $ListViewStateErrorCopyWith(ListViewStateError<T> value,
          $Res Function(ListViewStateError<T>) then) =
      _$ListViewStateErrorCopyWithImpl<T, $Res>;
  $Res call({int? statusCode, String? message, String? detail});
}

/// @nodoc
class _$ListViewStateErrorCopyWithImpl<T, $Res>
    extends _$ListViewStateCopyWithImpl<T, $Res>
    implements $ListViewStateErrorCopyWith<T, $Res> {
  _$ListViewStateErrorCopyWithImpl(
      ListViewStateError<T> _value, $Res Function(ListViewStateError<T>) _then)
      : super(_value, (v) => _then(v as ListViewStateError<T>));

  @override
  ListViewStateError<T> get _value => super._value as ListViewStateError<T>;

  @override
  $Res call({
    Object? statusCode = freezed,
    Object? message = freezed,
    Object? detail = freezed,
  }) {
    return _then(ListViewStateError<T>(
      statusCode: statusCode == freezed
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      detail: detail == freezed
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ListViewStateError<T> implements ListViewStateError<T> {
  const _$ListViewStateError({this.statusCode, this.message, this.detail});

  @override
  final int? statusCode;
  @override
  final String? message;
  @override
  final String? detail;

  @override
  String toString() {
    return 'ListViewState<$T>.error(statusCode: $statusCode, message: $message, detail: $detail)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ListViewStateError<T> &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.detail, detail) || other.detail == detail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statusCode, message, detail);

  @JsonKey(ignore: true)
  @override
  $ListViewStateErrorCopyWith<T, ListViewStateError<T>> get copyWith =>
      _$ListViewStateErrorCopyWithImpl<T, ListViewStateError<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<T> value) $default, {
    required TResult Function() loading,
    required TResult Function(int? statusCode, String? message, String? detail)
        error,
  }) {
    return error(statusCode, message, detail);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
  }) {
    return error?.call(statusCode, message, detail);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(statusCode, message, detail);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(ListViewStateData<T> value) $default, {
    required TResult Function(ListViewStateLoading<T> value) loading,
    required TResult Function(ListViewStateError<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(ListViewStateData<T> value)? $default, {
    TResult Function(ListViewStateLoading<T> value)? loading,
    TResult Function(ListViewStateError<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(ListViewStateData<T> value)? $default, {
    TResult Function(ListViewStateLoading<T> value)? loading,
    TResult Function(ListViewStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ListViewStateError<T> implements ListViewState<T> {
  const factory ListViewStateError(
      {int? statusCode,
      String? message,
      String? detail}) = _$ListViewStateError<T>;

  int? get statusCode;
  String? get message;
  String? get detail;
  @JsonKey(ignore: true)
  $ListViewStateErrorCopyWith<T, ListViewStateError<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$RefreshListViewStateTearOff {
  const _$RefreshListViewStateTearOff();

  RefreshListViewStateData<T> call<T>(
      {int pageNum = 0, required List<T> value}) {
    return RefreshListViewStateData<T>(
      pageNum: pageNum,
      value: value,
    );
  }

  RefreshListViewStateLoading<T> loading<T>() {
    return RefreshListViewStateLoading<T>();
  }

  RefreshListViewStateError<T> error<T>(
      {int? statusCode, String? message, String? detail}) {
    return RefreshListViewStateError<T>(
      statusCode: statusCode,
      message: message,
      detail: detail,
    );
  }
}

/// @nodoc
const $RefreshListViewState = _$RefreshListViewStateTearOff();

/// @nodoc
mixin _$RefreshListViewState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int pageNum, List<T> value) $default, {
    required TResult Function() loading,
    required TResult Function(int? statusCode, String? message, String? detail)
        error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(int pageNum, List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int pageNum, List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(RefreshListViewStateData<T> value) $default, {
    required TResult Function(RefreshListViewStateLoading<T> value) loading,
    required TResult Function(RefreshListViewStateError<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(RefreshListViewStateData<T> value)? $default, {
    TResult Function(RefreshListViewStateLoading<T> value)? loading,
    TResult Function(RefreshListViewStateError<T> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(RefreshListViewStateData<T> value)? $default, {
    TResult Function(RefreshListViewStateLoading<T> value)? loading,
    TResult Function(RefreshListViewStateError<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefreshListViewStateCopyWith<T, $Res> {
  factory $RefreshListViewStateCopyWith(RefreshListViewState<T> value,
          $Res Function(RefreshListViewState<T>) then) =
      _$RefreshListViewStateCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$RefreshListViewStateCopyWithImpl<T, $Res>
    implements $RefreshListViewStateCopyWith<T, $Res> {
  _$RefreshListViewStateCopyWithImpl(this._value, this._then);

  final RefreshListViewState<T> _value;
  // ignore: unused_field
  final $Res Function(RefreshListViewState<T>) _then;
}

/// @nodoc
abstract class $RefreshListViewStateDataCopyWith<T, $Res> {
  factory $RefreshListViewStateDataCopyWith(RefreshListViewStateData<T> value,
          $Res Function(RefreshListViewStateData<T>) then) =
      _$RefreshListViewStateDataCopyWithImpl<T, $Res>;
  $Res call({int pageNum, List<T> value});
}

/// @nodoc
class _$RefreshListViewStateDataCopyWithImpl<T, $Res>
    extends _$RefreshListViewStateCopyWithImpl<T, $Res>
    implements $RefreshListViewStateDataCopyWith<T, $Res> {
  _$RefreshListViewStateDataCopyWithImpl(RefreshListViewStateData<T> _value,
      $Res Function(RefreshListViewStateData<T>) _then)
      : super(_value, (v) => _then(v as RefreshListViewStateData<T>));

  @override
  RefreshListViewStateData<T> get _value =>
      super._value as RefreshListViewStateData<T>;

  @override
  $Res call({
    Object? pageNum = freezed,
    Object? value = freezed,
  }) {
    return _then(RefreshListViewStateData<T>(
      pageNum: pageNum == freezed
          ? _value.pageNum
          : pageNum // ignore: cast_nullable_to_non_nullable
              as int,
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ));
  }
}

/// @nodoc

class _$RefreshListViewStateData<T> implements RefreshListViewStateData<T> {
  const _$RefreshListViewStateData({this.pageNum = 0, required this.value});

  @JsonKey(defaultValue: 0)
  @override
  final int pageNum;
  @override
  final List<T> value;

  @override
  String toString() {
    return 'RefreshListViewState<$T>(pageNum: $pageNum, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RefreshListViewStateData<T> &&
            (identical(other.pageNum, pageNum) || other.pageNum == pageNum) &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, pageNum, const DeepCollectionEquality().hash(value));

  @JsonKey(ignore: true)
  @override
  $RefreshListViewStateDataCopyWith<T, RefreshListViewStateData<T>>
      get copyWith => _$RefreshListViewStateDataCopyWithImpl<T,
          RefreshListViewStateData<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int pageNum, List<T> value) $default, {
    required TResult Function() loading,
    required TResult Function(int? statusCode, String? message, String? detail)
        error,
  }) {
    return $default(pageNum, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(int pageNum, List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
  }) {
    return $default?.call(pageNum, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int pageNum, List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(pageNum, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(RefreshListViewStateData<T> value) $default, {
    required TResult Function(RefreshListViewStateLoading<T> value) loading,
    required TResult Function(RefreshListViewStateError<T> value) error,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(RefreshListViewStateData<T> value)? $default, {
    TResult Function(RefreshListViewStateLoading<T> value)? loading,
    TResult Function(RefreshListViewStateError<T> value)? error,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(RefreshListViewStateData<T> value)? $default, {
    TResult Function(RefreshListViewStateLoading<T> value)? loading,
    TResult Function(RefreshListViewStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class RefreshListViewStateData<T> implements RefreshListViewState<T> {
  const factory RefreshListViewStateData(
      {int pageNum, required List<T> value}) = _$RefreshListViewStateData<T>;

  int get pageNum;
  List<T> get value;
  @JsonKey(ignore: true)
  $RefreshListViewStateDataCopyWith<T, RefreshListViewStateData<T>>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefreshListViewStateLoadingCopyWith<T, $Res> {
  factory $RefreshListViewStateLoadingCopyWith(
          RefreshListViewStateLoading<T> value,
          $Res Function(RefreshListViewStateLoading<T>) then) =
      _$RefreshListViewStateLoadingCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$RefreshListViewStateLoadingCopyWithImpl<T, $Res>
    extends _$RefreshListViewStateCopyWithImpl<T, $Res>
    implements $RefreshListViewStateLoadingCopyWith<T, $Res> {
  _$RefreshListViewStateLoadingCopyWithImpl(
      RefreshListViewStateLoading<T> _value,
      $Res Function(RefreshListViewStateLoading<T>) _then)
      : super(_value, (v) => _then(v as RefreshListViewStateLoading<T>));

  @override
  RefreshListViewStateLoading<T> get _value =>
      super._value as RefreshListViewStateLoading<T>;
}

/// @nodoc

class _$RefreshListViewStateLoading<T>
    implements RefreshListViewStateLoading<T> {
  const _$RefreshListViewStateLoading();

  @override
  String toString() {
    return 'RefreshListViewState<$T>.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RefreshListViewStateLoading<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int pageNum, List<T> value) $default, {
    required TResult Function() loading,
    required TResult Function(int? statusCode, String? message, String? detail)
        error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(int pageNum, List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int pageNum, List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(RefreshListViewStateData<T> value) $default, {
    required TResult Function(RefreshListViewStateLoading<T> value) loading,
    required TResult Function(RefreshListViewStateError<T> value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(RefreshListViewStateData<T> value)? $default, {
    TResult Function(RefreshListViewStateLoading<T> value)? loading,
    TResult Function(RefreshListViewStateError<T> value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(RefreshListViewStateData<T> value)? $default, {
    TResult Function(RefreshListViewStateLoading<T> value)? loading,
    TResult Function(RefreshListViewStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class RefreshListViewStateLoading<T>
    implements RefreshListViewState<T> {
  const factory RefreshListViewStateLoading() =
      _$RefreshListViewStateLoading<T>;
}

/// @nodoc
abstract class $RefreshListViewStateErrorCopyWith<T, $Res> {
  factory $RefreshListViewStateErrorCopyWith(RefreshListViewStateError<T> value,
          $Res Function(RefreshListViewStateError<T>) then) =
      _$RefreshListViewStateErrorCopyWithImpl<T, $Res>;
  $Res call({int? statusCode, String? message, String? detail});
}

/// @nodoc
class _$RefreshListViewStateErrorCopyWithImpl<T, $Res>
    extends _$RefreshListViewStateCopyWithImpl<T, $Res>
    implements $RefreshListViewStateErrorCopyWith<T, $Res> {
  _$RefreshListViewStateErrorCopyWithImpl(RefreshListViewStateError<T> _value,
      $Res Function(RefreshListViewStateError<T>) _then)
      : super(_value, (v) => _then(v as RefreshListViewStateError<T>));

  @override
  RefreshListViewStateError<T> get _value =>
      super._value as RefreshListViewStateError<T>;

  @override
  $Res call({
    Object? statusCode = freezed,
    Object? message = freezed,
    Object? detail = freezed,
  }) {
    return _then(RefreshListViewStateError<T>(
      statusCode: statusCode == freezed
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      detail: detail == freezed
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$RefreshListViewStateError<T> implements RefreshListViewStateError<T> {
  const _$RefreshListViewStateError(
      {this.statusCode, this.message, this.detail});

  @override
  final int? statusCode;
  @override
  final String? message;
  @override
  final String? detail;

  @override
  String toString() {
    return 'RefreshListViewState<$T>.error(statusCode: $statusCode, message: $message, detail: $detail)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RefreshListViewStateError<T> &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.detail, detail) || other.detail == detail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statusCode, message, detail);

  @JsonKey(ignore: true)
  @override
  $RefreshListViewStateErrorCopyWith<T, RefreshListViewStateError<T>>
      get copyWith => _$RefreshListViewStateErrorCopyWithImpl<T,
          RefreshListViewStateError<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(int pageNum, List<T> value) $default, {
    required TResult Function() loading,
    required TResult Function(int? statusCode, String? message, String? detail)
        error,
  }) {
    return error(statusCode, message, detail);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult Function(int pageNum, List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
  }) {
    return error?.call(statusCode, message, detail);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(int pageNum, List<T> value)? $default, {
    TResult Function()? loading,
    TResult Function(int? statusCode, String? message, String? detail)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(statusCode, message, detail);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(RefreshListViewStateData<T> value) $default, {
    required TResult Function(RefreshListViewStateLoading<T> value) loading,
    required TResult Function(RefreshListViewStateError<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult Function(RefreshListViewStateData<T> value)? $default, {
    TResult Function(RefreshListViewStateLoading<T> value)? loading,
    TResult Function(RefreshListViewStateError<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(RefreshListViewStateData<T> value)? $default, {
    TResult Function(RefreshListViewStateLoading<T> value)? loading,
    TResult Function(RefreshListViewStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class RefreshListViewStateError<T> implements RefreshListViewState<T> {
  const factory RefreshListViewStateError(
      {int? statusCode,
      String? message,
      String? detail}) = _$RefreshListViewStateError<T>;

  int? get statusCode;
  String? get message;
  String? get detail;
  @JsonKey(ignore: true)
  $RefreshListViewStateErrorCopyWith<T, RefreshListViewStateError<T>>
      get copyWith => throw _privateConstructorUsedError;
}
