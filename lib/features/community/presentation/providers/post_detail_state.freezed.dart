// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PostDetailState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PaginatedResponse<CommunityComment> data) data,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PaginatedResponse<CommunityComment> data)? data,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PaginatedResponse<CommunityComment> data)? data,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PostDetailInitial value) initial,
    required TResult Function(PostDetailLoading value) loading,
    required TResult Function(PostDetailData value) data,
    required TResult Function(PostDetailError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PostDetailInitial value)? initial,
    TResult? Function(PostDetailLoading value)? loading,
    TResult? Function(PostDetailData value)? data,
    TResult? Function(PostDetailError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PostDetailInitial value)? initial,
    TResult Function(PostDetailLoading value)? loading,
    TResult Function(PostDetailData value)? data,
    TResult Function(PostDetailError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostDetailStateCopyWith<$Res> {
  factory $PostDetailStateCopyWith(
          PostDetailState value, $Res Function(PostDetailState) then) =
      _$PostDetailStateCopyWithImpl<$Res, PostDetailState>;
}

/// @nodoc
class _$PostDetailStateCopyWithImpl<$Res, $Val extends PostDetailState>
    implements $PostDetailStateCopyWith<$Res> {
  _$PostDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostDetailState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PostDetailInitialImplCopyWith<$Res> {
  factory _$$PostDetailInitialImplCopyWith(_$PostDetailInitialImpl value,
          $Res Function(_$PostDetailInitialImpl) then) =
      __$$PostDetailInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PostDetailInitialImplCopyWithImpl<$Res>
    extends _$PostDetailStateCopyWithImpl<$Res, _$PostDetailInitialImpl>
    implements _$$PostDetailInitialImplCopyWith<$Res> {
  __$$PostDetailInitialImplCopyWithImpl(_$PostDetailInitialImpl _value,
      $Res Function(_$PostDetailInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostDetailState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PostDetailInitialImpl implements PostDetailInitial {
  const _$PostDetailInitialImpl();

  @override
  String toString() {
    return 'PostDetailState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PostDetailInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PaginatedResponse<CommunityComment> data) data,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PaginatedResponse<CommunityComment> data)? data,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PaginatedResponse<CommunityComment> data)? data,
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
    required TResult Function(PostDetailInitial value) initial,
    required TResult Function(PostDetailLoading value) loading,
    required TResult Function(PostDetailData value) data,
    required TResult Function(PostDetailError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PostDetailInitial value)? initial,
    TResult? Function(PostDetailLoading value)? loading,
    TResult? Function(PostDetailData value)? data,
    TResult? Function(PostDetailError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PostDetailInitial value)? initial,
    TResult Function(PostDetailLoading value)? loading,
    TResult Function(PostDetailData value)? data,
    TResult Function(PostDetailError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class PostDetailInitial implements PostDetailState {
  const factory PostDetailInitial() = _$PostDetailInitialImpl;
}

/// @nodoc
abstract class _$$PostDetailLoadingImplCopyWith<$Res> {
  factory _$$PostDetailLoadingImplCopyWith(_$PostDetailLoadingImpl value,
          $Res Function(_$PostDetailLoadingImpl) then) =
      __$$PostDetailLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PostDetailLoadingImplCopyWithImpl<$Res>
    extends _$PostDetailStateCopyWithImpl<$Res, _$PostDetailLoadingImpl>
    implements _$$PostDetailLoadingImplCopyWith<$Res> {
  __$$PostDetailLoadingImplCopyWithImpl(_$PostDetailLoadingImpl _value,
      $Res Function(_$PostDetailLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostDetailState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PostDetailLoadingImpl implements PostDetailLoading {
  const _$PostDetailLoadingImpl();

  @override
  String toString() {
    return 'PostDetailState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PostDetailLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PaginatedResponse<CommunityComment> data) data,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PaginatedResponse<CommunityComment> data)? data,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PaginatedResponse<CommunityComment> data)? data,
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
    required TResult Function(PostDetailInitial value) initial,
    required TResult Function(PostDetailLoading value) loading,
    required TResult Function(PostDetailData value) data,
    required TResult Function(PostDetailError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PostDetailInitial value)? initial,
    TResult? Function(PostDetailLoading value)? loading,
    TResult? Function(PostDetailData value)? data,
    TResult? Function(PostDetailError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PostDetailInitial value)? initial,
    TResult Function(PostDetailLoading value)? loading,
    TResult Function(PostDetailData value)? data,
    TResult Function(PostDetailError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class PostDetailLoading implements PostDetailState {
  const factory PostDetailLoading() = _$PostDetailLoadingImpl;
}

/// @nodoc
abstract class _$$PostDetailDataImplCopyWith<$Res> {
  factory _$$PostDetailDataImplCopyWith(_$PostDetailDataImpl value,
          $Res Function(_$PostDetailDataImpl) then) =
      __$$PostDetailDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PaginatedResponse<CommunityComment> data});
}

/// @nodoc
class __$$PostDetailDataImplCopyWithImpl<$Res>
    extends _$PostDetailStateCopyWithImpl<$Res, _$PostDetailDataImpl>
    implements _$$PostDetailDataImplCopyWith<$Res> {
  __$$PostDetailDataImplCopyWithImpl(
      _$PostDetailDataImpl _value, $Res Function(_$PostDetailDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$PostDetailDataImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as PaginatedResponse<CommunityComment>,
    ));
  }
}

/// @nodoc

class _$PostDetailDataImpl implements PostDetailData {
  const _$PostDetailDataImpl(this.data);

  @override
  final PaginatedResponse<CommunityComment> data;

  @override
  String toString() {
    return 'PostDetailState.data(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostDetailDataImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of PostDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostDetailDataImplCopyWith<_$PostDetailDataImpl> get copyWith =>
      __$$PostDetailDataImplCopyWithImpl<_$PostDetailDataImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PaginatedResponse<CommunityComment> data) data,
    required TResult Function(String message) error,
  }) {
    return data(this.data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PaginatedResponse<CommunityComment> data)? data,
    TResult? Function(String message)? error,
  }) {
    return data?.call(this.data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PaginatedResponse<CommunityComment> data)? data,
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
    required TResult Function(PostDetailInitial value) initial,
    required TResult Function(PostDetailLoading value) loading,
    required TResult Function(PostDetailData value) data,
    required TResult Function(PostDetailError value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PostDetailInitial value)? initial,
    TResult? Function(PostDetailLoading value)? loading,
    TResult? Function(PostDetailData value)? data,
    TResult? Function(PostDetailError value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PostDetailInitial value)? initial,
    TResult Function(PostDetailLoading value)? loading,
    TResult Function(PostDetailData value)? data,
    TResult Function(PostDetailError value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class PostDetailData implements PostDetailState {
  const factory PostDetailData(final PaginatedResponse<CommunityComment> data) =
      _$PostDetailDataImpl;

  PaginatedResponse<CommunityComment> get data;

  /// Create a copy of PostDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostDetailDataImplCopyWith<_$PostDetailDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PostDetailErrorImplCopyWith<$Res> {
  factory _$$PostDetailErrorImplCopyWith(_$PostDetailErrorImpl value,
          $Res Function(_$PostDetailErrorImpl) then) =
      __$$PostDetailErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PostDetailErrorImplCopyWithImpl<$Res>
    extends _$PostDetailStateCopyWithImpl<$Res, _$PostDetailErrorImpl>
    implements _$$PostDetailErrorImplCopyWith<$Res> {
  __$$PostDetailErrorImplCopyWithImpl(
      _$PostDetailErrorImpl _value, $Res Function(_$PostDetailErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$PostDetailErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PostDetailErrorImpl implements PostDetailError {
  const _$PostDetailErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'PostDetailState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostDetailErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of PostDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostDetailErrorImplCopyWith<_$PostDetailErrorImpl> get copyWith =>
      __$$PostDetailErrorImplCopyWithImpl<_$PostDetailErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PaginatedResponse<CommunityComment> data) data,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PaginatedResponse<CommunityComment> data)? data,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PaginatedResponse<CommunityComment> data)? data,
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
    required TResult Function(PostDetailInitial value) initial,
    required TResult Function(PostDetailLoading value) loading,
    required TResult Function(PostDetailData value) data,
    required TResult Function(PostDetailError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PostDetailInitial value)? initial,
    TResult? Function(PostDetailLoading value)? loading,
    TResult? Function(PostDetailData value)? data,
    TResult? Function(PostDetailError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PostDetailInitial value)? initial,
    TResult Function(PostDetailLoading value)? loading,
    TResult Function(PostDetailData value)? data,
    TResult Function(PostDetailError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class PostDetailError implements PostDetailState {
  const factory PostDetailError(final String message) = _$PostDetailErrorImpl;

  String get message;

  /// Create a copy of PostDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostDetailErrorImplCopyWith<_$PostDetailErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
