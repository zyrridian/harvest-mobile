// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AddressState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Address> data) data,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Address> data)? data,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Address> data)? data,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AddressInitial value) initial,
    required TResult Function(AddressLoading value) loading,
    required TResult Function(AddressData value) data,
    required TResult Function(AddressError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressInitial value)? initial,
    TResult? Function(AddressLoading value)? loading,
    TResult? Function(AddressData value)? data,
    TResult? Function(AddressError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressInitial value)? initial,
    TResult Function(AddressLoading value)? loading,
    TResult Function(AddressData value)? data,
    TResult Function(AddressError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressStateCopyWith<$Res> {
  factory $AddressStateCopyWith(
          AddressState value, $Res Function(AddressState) then) =
      _$AddressStateCopyWithImpl<$Res, AddressState>;
}

/// @nodoc
class _$AddressStateCopyWithImpl<$Res, $Val extends AddressState>
    implements $AddressStateCopyWith<$Res> {
  _$AddressStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AddressInitialImplCopyWith<$Res> {
  factory _$$AddressInitialImplCopyWith(_$AddressInitialImpl value,
          $Res Function(_$AddressInitialImpl) then) =
      __$$AddressInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AddressInitialImplCopyWithImpl<$Res>
    extends _$AddressStateCopyWithImpl<$Res, _$AddressInitialImpl>
    implements _$$AddressInitialImplCopyWith<$Res> {
  __$$AddressInitialImplCopyWithImpl(
      _$AddressInitialImpl _value, $Res Function(_$AddressInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddressState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AddressInitialImpl implements AddressInitial {
  const _$AddressInitialImpl();

  @override
  String toString() {
    return 'AddressState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AddressInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Address> data) data,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Address> data)? data,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Address> data)? data,
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
    required TResult Function(AddressInitial value) initial,
    required TResult Function(AddressLoading value) loading,
    required TResult Function(AddressData value) data,
    required TResult Function(AddressError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressInitial value)? initial,
    TResult? Function(AddressLoading value)? loading,
    TResult? Function(AddressData value)? data,
    TResult? Function(AddressError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressInitial value)? initial,
    TResult Function(AddressLoading value)? loading,
    TResult Function(AddressData value)? data,
    TResult Function(AddressError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class AddressInitial implements AddressState {
  const factory AddressInitial() = _$AddressInitialImpl;
}

/// @nodoc
abstract class _$$AddressLoadingImplCopyWith<$Res> {
  factory _$$AddressLoadingImplCopyWith(_$AddressLoadingImpl value,
          $Res Function(_$AddressLoadingImpl) then) =
      __$$AddressLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AddressLoadingImplCopyWithImpl<$Res>
    extends _$AddressStateCopyWithImpl<$Res, _$AddressLoadingImpl>
    implements _$$AddressLoadingImplCopyWith<$Res> {
  __$$AddressLoadingImplCopyWithImpl(
      _$AddressLoadingImpl _value, $Res Function(_$AddressLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddressState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AddressLoadingImpl implements AddressLoading {
  const _$AddressLoadingImpl();

  @override
  String toString() {
    return 'AddressState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AddressLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Address> data) data,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Address> data)? data,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Address> data)? data,
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
    required TResult Function(AddressInitial value) initial,
    required TResult Function(AddressLoading value) loading,
    required TResult Function(AddressData value) data,
    required TResult Function(AddressError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressInitial value)? initial,
    TResult? Function(AddressLoading value)? loading,
    TResult? Function(AddressData value)? data,
    TResult? Function(AddressError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressInitial value)? initial,
    TResult Function(AddressLoading value)? loading,
    TResult Function(AddressData value)? data,
    TResult Function(AddressError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class AddressLoading implements AddressState {
  const factory AddressLoading() = _$AddressLoadingImpl;
}

/// @nodoc
abstract class _$$AddressDataImplCopyWith<$Res> {
  factory _$$AddressDataImplCopyWith(
          _$AddressDataImpl value, $Res Function(_$AddressDataImpl) then) =
      __$$AddressDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Address> data});
}

/// @nodoc
class __$$AddressDataImplCopyWithImpl<$Res>
    extends _$AddressStateCopyWithImpl<$Res, _$AddressDataImpl>
    implements _$$AddressDataImplCopyWith<$Res> {
  __$$AddressDataImplCopyWithImpl(
      _$AddressDataImpl _value, $Res Function(_$AddressDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddressState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$AddressDataImpl(
      null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Address>,
    ));
  }
}

/// @nodoc

class _$AddressDataImpl implements AddressData {
  const _$AddressDataImpl(final List<Address> data) : _data = data;

  final List<Address> _data;
  @override
  List<Address> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'AddressState.data(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressDataImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of AddressState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressDataImplCopyWith<_$AddressDataImpl> get copyWith =>
      __$$AddressDataImplCopyWithImpl<_$AddressDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Address> data) data,
    required TResult Function(String message) error,
  }) {
    return data(this.data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Address> data)? data,
    TResult? Function(String message)? error,
  }) {
    return data?.call(this.data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Address> data)? data,
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
    required TResult Function(AddressInitial value) initial,
    required TResult Function(AddressLoading value) loading,
    required TResult Function(AddressData value) data,
    required TResult Function(AddressError value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressInitial value)? initial,
    TResult? Function(AddressLoading value)? loading,
    TResult? Function(AddressData value)? data,
    TResult? Function(AddressError value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressInitial value)? initial,
    TResult Function(AddressLoading value)? loading,
    TResult Function(AddressData value)? data,
    TResult Function(AddressError value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class AddressData implements AddressState {
  const factory AddressData(final List<Address> data) = _$AddressDataImpl;

  List<Address> get data;

  /// Create a copy of AddressState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressDataImplCopyWith<_$AddressDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddressErrorImplCopyWith<$Res> {
  factory _$$AddressErrorImplCopyWith(
          _$AddressErrorImpl value, $Res Function(_$AddressErrorImpl) then) =
      __$$AddressErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AddressErrorImplCopyWithImpl<$Res>
    extends _$AddressStateCopyWithImpl<$Res, _$AddressErrorImpl>
    implements _$$AddressErrorImplCopyWith<$Res> {
  __$$AddressErrorImplCopyWithImpl(
      _$AddressErrorImpl _value, $Res Function(_$AddressErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddressState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$AddressErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AddressErrorImpl implements AddressError {
  const _$AddressErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AddressState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AddressState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressErrorImplCopyWith<_$AddressErrorImpl> get copyWith =>
      __$$AddressErrorImplCopyWithImpl<_$AddressErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Address> data) data,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Address> data)? data,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Address> data)? data,
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
    required TResult Function(AddressInitial value) initial,
    required TResult Function(AddressLoading value) loading,
    required TResult Function(AddressData value) data,
    required TResult Function(AddressError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AddressInitial value)? initial,
    TResult? Function(AddressLoading value)? loading,
    TResult? Function(AddressData value)? data,
    TResult? Function(AddressError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AddressInitial value)? initial,
    TResult Function(AddressLoading value)? loading,
    TResult Function(AddressData value)? data,
    TResult Function(AddressError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class AddressError implements AddressState {
  const factory AddressError(final String message) = _$AddressErrorImpl;

  String get message;

  /// Create a copy of AddressState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressErrorImplCopyWith<_$AddressErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
