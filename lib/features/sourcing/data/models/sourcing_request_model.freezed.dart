// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sourcing_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SourcingBuyerModel _$SourcingBuyerModelFromJson(Map<String, dynamic> json) {
  return _SourcingBuyerModel.fromJson(json);
}

/// @nodoc
mixin _$SourcingBuyerModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// Serializes this SourcingBuyerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SourcingBuyerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SourcingBuyerModelCopyWith<SourcingBuyerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SourcingBuyerModelCopyWith<$Res> {
  factory $SourcingBuyerModelCopyWith(
          SourcingBuyerModel value, $Res Function(SourcingBuyerModel) then) =
      _$SourcingBuyerModelCopyWithImpl<$Res, SourcingBuyerModel>;
  @useResult
  $Res call(
      {String id, String name, @JsonKey(name: 'avatar_url') String? avatarUrl});
}

/// @nodoc
class _$SourcingBuyerModelCopyWithImpl<$Res, $Val extends SourcingBuyerModel>
    implements $SourcingBuyerModelCopyWith<$Res> {
  _$SourcingBuyerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SourcingBuyerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SourcingBuyerModelImplCopyWith<$Res>
    implements $SourcingBuyerModelCopyWith<$Res> {
  factory _$$SourcingBuyerModelImplCopyWith(_$SourcingBuyerModelImpl value,
          $Res Function(_$SourcingBuyerModelImpl) then) =
      __$$SourcingBuyerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String name, @JsonKey(name: 'avatar_url') String? avatarUrl});
}

/// @nodoc
class __$$SourcingBuyerModelImplCopyWithImpl<$Res>
    extends _$SourcingBuyerModelCopyWithImpl<$Res, _$SourcingBuyerModelImpl>
    implements _$$SourcingBuyerModelImplCopyWith<$Res> {
  __$$SourcingBuyerModelImplCopyWithImpl(_$SourcingBuyerModelImpl _value,
      $Res Function(_$SourcingBuyerModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SourcingBuyerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(_$SourcingBuyerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SourcingBuyerModelImpl implements _SourcingBuyerModel {
  const _$SourcingBuyerModelImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'avatar_url') this.avatarUrl});

  factory _$SourcingBuyerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SourcingBuyerModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  @override
  String toString() {
    return 'SourcingBuyerModel(id: $id, name: $name, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SourcingBuyerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, avatarUrl);

  /// Create a copy of SourcingBuyerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SourcingBuyerModelImplCopyWith<_$SourcingBuyerModelImpl> get copyWith =>
      __$$SourcingBuyerModelImplCopyWithImpl<_$SourcingBuyerModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SourcingBuyerModelImplToJson(
      this,
    );
  }
}

abstract class _SourcingBuyerModel implements SourcingBuyerModel {
  const factory _SourcingBuyerModel(
          {required final String id,
          required final String name,
          @JsonKey(name: 'avatar_url') final String? avatarUrl}) =
      _$SourcingBuyerModelImpl;

  factory _SourcingBuyerModel.fromJson(Map<String, dynamic> json) =
      _$SourcingBuyerModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;

  /// Create a copy of SourcingBuyerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SourcingBuyerModelImplCopyWith<_$SourcingBuyerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SourcingRequestModel _$SourcingRequestModelFromJson(Map<String, dynamic> json) {
  return _SourcingRequestModel.fromJson(json);
}

/// @nodoc
mixin _$SourcingRequestModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double? get budget => throw _privateConstructorUsedError;
  @JsonKey(name: 'required_by')
  DateTime? get requiredBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'offers_count', defaultValue: 0)
  int get offersCount => throw _privateConstructorUsedError;
  SourcingBuyerModel? get buyer => throw _privateConstructorUsedError;

  /// Serializes this SourcingRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SourcingRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SourcingRequestModelCopyWith<SourcingRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SourcingRequestModelCopyWith<$Res> {
  factory $SourcingRequestModelCopyWith(SourcingRequestModel value,
          $Res Function(SourcingRequestModel) then) =
      _$SourcingRequestModelCopyWithImpl<$Res, SourcingRequestModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String status,
      double? budget,
      @JsonKey(name: 'required_by') DateTime? requiredBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'offers_count', defaultValue: 0) int offersCount,
      SourcingBuyerModel? buyer});

  $SourcingBuyerModelCopyWith<$Res>? get buyer;
}

/// @nodoc
class _$SourcingRequestModelCopyWithImpl<$Res,
        $Val extends SourcingRequestModel>
    implements $SourcingRequestModelCopyWith<$Res> {
  _$SourcingRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SourcingRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? status = null,
    Object? budget = freezed,
    Object? requiredBy = freezed,
    Object? createdAt = null,
    Object? offersCount = null,
    Object? buyer = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as double?,
      requiredBy: freezed == requiredBy
          ? _value.requiredBy
          : requiredBy // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      offersCount: null == offersCount
          ? _value.offersCount
          : offersCount // ignore: cast_nullable_to_non_nullable
              as int,
      buyer: freezed == buyer
          ? _value.buyer
          : buyer // ignore: cast_nullable_to_non_nullable
              as SourcingBuyerModel?,
    ) as $Val);
  }

  /// Create a copy of SourcingRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SourcingBuyerModelCopyWith<$Res>? get buyer {
    if (_value.buyer == null) {
      return null;
    }

    return $SourcingBuyerModelCopyWith<$Res>(_value.buyer!, (value) {
      return _then(_value.copyWith(buyer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SourcingRequestModelImplCopyWith<$Res>
    implements $SourcingRequestModelCopyWith<$Res> {
  factory _$$SourcingRequestModelImplCopyWith(_$SourcingRequestModelImpl value,
          $Res Function(_$SourcingRequestModelImpl) then) =
      __$$SourcingRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String status,
      double? budget,
      @JsonKey(name: 'required_by') DateTime? requiredBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'offers_count', defaultValue: 0) int offersCount,
      SourcingBuyerModel? buyer});

  @override
  $SourcingBuyerModelCopyWith<$Res>? get buyer;
}

/// @nodoc
class __$$SourcingRequestModelImplCopyWithImpl<$Res>
    extends _$SourcingRequestModelCopyWithImpl<$Res, _$SourcingRequestModelImpl>
    implements _$$SourcingRequestModelImplCopyWith<$Res> {
  __$$SourcingRequestModelImplCopyWithImpl(_$SourcingRequestModelImpl _value,
      $Res Function(_$SourcingRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SourcingRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? status = null,
    Object? budget = freezed,
    Object? requiredBy = freezed,
    Object? createdAt = null,
    Object? offersCount = null,
    Object? buyer = freezed,
  }) {
    return _then(_$SourcingRequestModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      budget: freezed == budget
          ? _value.budget
          : budget // ignore: cast_nullable_to_non_nullable
              as double?,
      requiredBy: freezed == requiredBy
          ? _value.requiredBy
          : requiredBy // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      offersCount: null == offersCount
          ? _value.offersCount
          : offersCount // ignore: cast_nullable_to_non_nullable
              as int,
      buyer: freezed == buyer
          ? _value.buyer
          : buyer // ignore: cast_nullable_to_non_nullable
              as SourcingBuyerModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SourcingRequestModelImpl implements _SourcingRequestModel {
  const _$SourcingRequestModelImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.status,
      this.budget,
      @JsonKey(name: 'required_by') this.requiredBy,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'offers_count', defaultValue: 0) required this.offersCount,
      this.buyer});

  factory _$SourcingRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SourcingRequestModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String status;
  @override
  final double? budget;
  @override
  @JsonKey(name: 'required_by')
  final DateTime? requiredBy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'offers_count', defaultValue: 0)
  final int offersCount;
  @override
  final SourcingBuyerModel? buyer;

  @override
  String toString() {
    return 'SourcingRequestModel(id: $id, title: $title, description: $description, status: $status, budget: $budget, requiredBy: $requiredBy, createdAt: $createdAt, offersCount: $offersCount, buyer: $buyer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SourcingRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.budget, budget) || other.budget == budget) &&
            (identical(other.requiredBy, requiredBy) ||
                other.requiredBy == requiredBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.offersCount, offersCount) ||
                other.offersCount == offersCount) &&
            (identical(other.buyer, buyer) || other.buyer == buyer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, status,
      budget, requiredBy, createdAt, offersCount, buyer);

  /// Create a copy of SourcingRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SourcingRequestModelImplCopyWith<_$SourcingRequestModelImpl>
      get copyWith =>
          __$$SourcingRequestModelImplCopyWithImpl<_$SourcingRequestModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SourcingRequestModelImplToJson(
      this,
    );
  }
}

abstract class _SourcingRequestModel implements SourcingRequestModel {
  const factory _SourcingRequestModel(
      {required final String id,
      required final String title,
      required final String description,
      required final String status,
      final double? budget,
      @JsonKey(name: 'required_by') final DateTime? requiredBy,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'offers_count', defaultValue: 0)
      required final int offersCount,
      final SourcingBuyerModel? buyer}) = _$SourcingRequestModelImpl;

  factory _SourcingRequestModel.fromJson(Map<String, dynamic> json) =
      _$SourcingRequestModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get status;
  @override
  double? get budget;
  @override
  @JsonKey(name: 'required_by')
  DateTime? get requiredBy;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'offers_count', defaultValue: 0)
  int get offersCount;
  @override
  SourcingBuyerModel? get buyer;

  /// Create a copy of SourcingRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SourcingRequestModelImplCopyWith<_$SourcingRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
