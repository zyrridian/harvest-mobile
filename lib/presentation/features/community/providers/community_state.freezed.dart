// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CommunityState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PaginatedResponse<CommunityPost> data) data,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PaginatedResponse<CommunityPost> data)? data,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PaginatedResponse<CommunityPost> data)? data,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommunityInitial value) initial,
    required TResult Function(CommunityLoading value) loading,
    required TResult Function(CommunityData value) data,
    required TResult Function(CommunityError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommunityInitial value)? initial,
    TResult? Function(CommunityLoading value)? loading,
    TResult? Function(CommunityData value)? data,
    TResult? Function(CommunityError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommunityInitial value)? initial,
    TResult Function(CommunityLoading value)? loading,
    TResult Function(CommunityData value)? data,
    TResult Function(CommunityError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunityStateCopyWith<$Res> {
  factory $CommunityStateCopyWith(
          CommunityState value, $Res Function(CommunityState) then) =
      _$CommunityStateCopyWithImpl<$Res, CommunityState>;
}

/// @nodoc
class _$CommunityStateCopyWithImpl<$Res, $Val extends CommunityState>
    implements $CommunityStateCopyWith<$Res> {
  _$CommunityStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommunityState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CommunityInitialImplCopyWith<$Res> {
  factory _$$CommunityInitialImplCopyWith(_$CommunityInitialImpl value,
          $Res Function(_$CommunityInitialImpl) then) =
      __$$CommunityInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CommunityInitialImplCopyWithImpl<$Res>
    extends _$CommunityStateCopyWithImpl<$Res, _$CommunityInitialImpl>
    implements _$$CommunityInitialImplCopyWith<$Res> {
  __$$CommunityInitialImplCopyWithImpl(_$CommunityInitialImpl _value,
      $Res Function(_$CommunityInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommunityState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CommunityInitialImpl implements CommunityInitial {
  const _$CommunityInitialImpl();

  @override
  String toString() {
    return 'CommunityState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CommunityInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PaginatedResponse<CommunityPost> data) data,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PaginatedResponse<CommunityPost> data)? data,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PaginatedResponse<CommunityPost> data)? data,
    TResult Function(String message)? error,
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
    required TResult Function(CommunityInitial value) initial,
    required TResult Function(CommunityLoading value) loading,
    required TResult Function(CommunityData value) data,
    required TResult Function(CommunityError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommunityInitial value)? initial,
    TResult? Function(CommunityLoading value)? loading,
    TResult? Function(CommunityData value)? data,
    TResult? Function(CommunityError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommunityInitial value)? initial,
    TResult Function(CommunityLoading value)? loading,
    TResult Function(CommunityData value)? data,
    TResult Function(CommunityError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class CommunityInitial implements CommunityState {
  const factory CommunityInitial() = _$CommunityInitialImpl;
}

/// @nodoc
abstract class _$$CommunityLoadingImplCopyWith<$Res> {
  factory _$$CommunityLoadingImplCopyWith(_$CommunityLoadingImpl value,
          $Res Function(_$CommunityLoadingImpl) then) =
      __$$CommunityLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CommunityLoadingImplCopyWithImpl<$Res>
    extends _$CommunityStateCopyWithImpl<$Res, _$CommunityLoadingImpl>
    implements _$$CommunityLoadingImplCopyWith<$Res> {
  __$$CommunityLoadingImplCopyWithImpl(_$CommunityLoadingImpl _value,
      $Res Function(_$CommunityLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommunityState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CommunityLoadingImpl implements CommunityLoading {
  const _$CommunityLoadingImpl();

  @override
  String toString() {
    return 'CommunityState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CommunityLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PaginatedResponse<CommunityPost> data) data,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PaginatedResponse<CommunityPost> data)? data,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PaginatedResponse<CommunityPost> data)? data,
    TResult Function(String message)? error,
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
    required TResult Function(CommunityInitial value) initial,
    required TResult Function(CommunityLoading value) loading,
    required TResult Function(CommunityData value) data,
    required TResult Function(CommunityError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommunityInitial value)? initial,
    TResult? Function(CommunityLoading value)? loading,
    TResult? Function(CommunityData value)? data,
    TResult? Function(CommunityError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommunityInitial value)? initial,
    TResult Function(CommunityLoading value)? loading,
    TResult Function(CommunityData value)? data,
    TResult Function(CommunityError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class CommunityLoading implements CommunityState {
  const factory CommunityLoading() = _$CommunityLoadingImpl;
}

/// @nodoc
abstract class _$$CommunityDataImplCopyWith<$Res> {
  factory _$$CommunityDataImplCopyWith(
          _$CommunityDataImpl value, $Res Function(_$CommunityDataImpl) then) =
      __$$CommunityDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PaginatedResponse<CommunityPost> data});
}

/// @nodoc
class __$$CommunityDataImplCopyWithImpl<$Res>
    extends _$CommunityStateCopyWithImpl<$Res, _$CommunityDataImpl>
    implements _$$CommunityDataImplCopyWith<$Res> {
  __$$CommunityDataImplCopyWithImpl(
      _$CommunityDataImpl _value, $Res Function(_$CommunityDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommunityState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$CommunityDataImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as PaginatedResponse<CommunityPost>,
    ));
  }
}

/// @nodoc

class _$CommunityDataImpl implements CommunityData {
  const _$CommunityDataImpl(this.data);

  @override
  final PaginatedResponse<CommunityPost> data;

  @override
  String toString() {
    return 'CommunityState.data(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityDataImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of CommunityState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityDataImplCopyWith<_$CommunityDataImpl> get copyWith =>
      __$$CommunityDataImplCopyWithImpl<_$CommunityDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PaginatedResponse<CommunityPost> data) data,
    required TResult Function(String message) error,
  }) {
    return data(this.data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PaginatedResponse<CommunityPost> data)? data,
    TResult? Function(String message)? error,
  }) {
    return data?.call(this.data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PaginatedResponse<CommunityPost> data)? data,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this.data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommunityInitial value) initial,
    required TResult Function(CommunityLoading value) loading,
    required TResult Function(CommunityData value) data,
    required TResult Function(CommunityError value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommunityInitial value)? initial,
    TResult? Function(CommunityLoading value)? loading,
    TResult? Function(CommunityData value)? data,
    TResult? Function(CommunityError value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommunityInitial value)? initial,
    TResult Function(CommunityLoading value)? loading,
    TResult Function(CommunityData value)? data,
    TResult Function(CommunityError value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class CommunityData implements CommunityState {
  const factory CommunityData(final PaginatedResponse<CommunityPost> data) =
      _$CommunityDataImpl;

  PaginatedResponse<CommunityPost> get data;

  /// Create a copy of CommunityState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunityDataImplCopyWith<_$CommunityDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CommunityErrorImplCopyWith<$Res> {
  factory _$$CommunityErrorImplCopyWith(_$CommunityErrorImpl value,
          $Res Function(_$CommunityErrorImpl) then) =
      __$$CommunityErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$CommunityErrorImplCopyWithImpl<$Res>
    extends _$CommunityStateCopyWithImpl<$Res, _$CommunityErrorImpl>
    implements _$$CommunityErrorImplCopyWith<$Res> {
  __$$CommunityErrorImplCopyWithImpl(
      _$CommunityErrorImpl _value, $Res Function(_$CommunityErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommunityState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$CommunityErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CommunityErrorImpl implements CommunityError {
  const _$CommunityErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'CommunityState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunityErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of CommunityState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunityErrorImplCopyWith<_$CommunityErrorImpl> get copyWith =>
      __$$CommunityErrorImplCopyWithImpl<_$CommunityErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PaginatedResponse<CommunityPost> data) data,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PaginatedResponse<CommunityPost> data)? data,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PaginatedResponse<CommunityPost> data)? data,
    TResult Function(String message)? error,
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
    required TResult Function(CommunityInitial value) initial,
    required TResult Function(CommunityLoading value) loading,
    required TResult Function(CommunityData value) data,
    required TResult Function(CommunityError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommunityInitial value)? initial,
    TResult? Function(CommunityLoading value)? loading,
    TResult? Function(CommunityData value)? data,
    TResult? Function(CommunityError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommunityInitial value)? initial,
    TResult Function(CommunityLoading value)? loading,
    TResult Function(CommunityData value)? data,
    TResult Function(CommunityError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class CommunityError implements CommunityState {
  const factory CommunityError(final String message) = _$CommunityErrorImpl;

  String get message;

  /// Create a copy of CommunityState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommunityErrorImplCopyWith<_$CommunityErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
