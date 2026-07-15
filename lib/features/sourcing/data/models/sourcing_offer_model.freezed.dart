// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sourcing_offer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SourcingOfferFarmerModel _$SourcingOfferFarmerModelFromJson(
    Map<String, dynamic> json) {
  return _SourcingOfferFarmerModel.fromJson(json);
}

/// @nodoc
mixin _$SourcingOfferFarmerModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_image')
  String? get profileImage => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified')
  bool get isVerified => throw _privateConstructorUsedError;

  /// Serializes this SourcingOfferFarmerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SourcingOfferFarmerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SourcingOfferFarmerModelCopyWith<SourcingOfferFarmerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SourcingOfferFarmerModelCopyWith<$Res> {
  factory $SourcingOfferFarmerModelCopyWith(SourcingOfferFarmerModel value,
          $Res Function(SourcingOfferFarmerModel) then) =
      _$SourcingOfferFarmerModelCopyWithImpl<$Res, SourcingOfferFarmerModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'profile_image') String? profileImage,
      double rating,
      @JsonKey(name: 'is_verified') bool isVerified});
}

/// @nodoc
class _$SourcingOfferFarmerModelCopyWithImpl<$Res,
        $Val extends SourcingOfferFarmerModel>
    implements $SourcingOfferFarmerModelCopyWith<$Res> {
  _$SourcingOfferFarmerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SourcingOfferFarmerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? profileImage = freezed,
    Object? rating = null,
    Object? isVerified = null,
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
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SourcingOfferFarmerModelImplCopyWith<$Res>
    implements $SourcingOfferFarmerModelCopyWith<$Res> {
  factory _$$SourcingOfferFarmerModelImplCopyWith(
          _$SourcingOfferFarmerModelImpl value,
          $Res Function(_$SourcingOfferFarmerModelImpl) then) =
      __$$SourcingOfferFarmerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'profile_image') String? profileImage,
      double rating,
      @JsonKey(name: 'is_verified') bool isVerified});
}

/// @nodoc
class __$$SourcingOfferFarmerModelImplCopyWithImpl<$Res>
    extends _$SourcingOfferFarmerModelCopyWithImpl<$Res,
        _$SourcingOfferFarmerModelImpl>
    implements _$$SourcingOfferFarmerModelImplCopyWith<$Res> {
  __$$SourcingOfferFarmerModelImplCopyWithImpl(
      _$SourcingOfferFarmerModelImpl _value,
      $Res Function(_$SourcingOfferFarmerModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SourcingOfferFarmerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? profileImage = freezed,
    Object? rating = null,
    Object? isVerified = null,
  }) {
    return _then(_$SourcingOfferFarmerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _value.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SourcingOfferFarmerModelImpl implements _SourcingOfferFarmerModel {
  const _$SourcingOfferFarmerModelImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'profile_image') this.profileImage,
      required this.rating,
      @JsonKey(name: 'is_verified') required this.isVerified});

  factory _$SourcingOfferFarmerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SourcingOfferFarmerModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  @override
  final double rating;
  @override
  @JsonKey(name: 'is_verified')
  final bool isVerified;

  @override
  String toString() {
    return 'SourcingOfferFarmerModel(id: $id, name: $name, profileImage: $profileImage, rating: $rating, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SourcingOfferFarmerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, profileImage, rating, isVerified);

  /// Create a copy of SourcingOfferFarmerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SourcingOfferFarmerModelImplCopyWith<_$SourcingOfferFarmerModelImpl>
      get copyWith => __$$SourcingOfferFarmerModelImplCopyWithImpl<
          _$SourcingOfferFarmerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SourcingOfferFarmerModelImplToJson(
      this,
    );
  }
}

abstract class _SourcingOfferFarmerModel implements SourcingOfferFarmerModel {
  const factory _SourcingOfferFarmerModel(
          {required final String id,
          required final String name,
          @JsonKey(name: 'profile_image') final String? profileImage,
          required final double rating,
          @JsonKey(name: 'is_verified') required final bool isVerified}) =
      _$SourcingOfferFarmerModelImpl;

  factory _SourcingOfferFarmerModel.fromJson(Map<String, dynamic> json) =
      _$SourcingOfferFarmerModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'profile_image')
  String? get profileImage;
  @override
  double get rating;
  @override
  @JsonKey(name: 'is_verified')
  bool get isVerified;

  /// Create a copy of SourcingOfferFarmerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SourcingOfferFarmerModelImplCopyWith<_$SourcingOfferFarmerModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SourcingOfferModel _$SourcingOfferModelFromJson(Map<String, dynamic> json) {
  return _SourcingOfferModel.fromJson(json);
}

/// @nodoc
mixin _$SourcingOfferModel {
  String get id => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  SourcingOfferFarmerModel? get farmer => throw _privateConstructorUsedError;

  /// Serializes this SourcingOfferModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SourcingOfferModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SourcingOfferModelCopyWith<SourcingOfferModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SourcingOfferModelCopyWith<$Res> {
  factory $SourcingOfferModelCopyWith(
          SourcingOfferModel value, $Res Function(SourcingOfferModel) then) =
      _$SourcingOfferModelCopyWithImpl<$Res, SourcingOfferModel>;
  @useResult
  $Res call(
      {String id,
      double price,
      String? notes,
      String status,
      @JsonKey(name: 'created_at') DateTime createdAt,
      SourcingOfferFarmerModel? farmer});

  $SourcingOfferFarmerModelCopyWith<$Res>? get farmer;
}

/// @nodoc
class _$SourcingOfferModelCopyWithImpl<$Res, $Val extends SourcingOfferModel>
    implements $SourcingOfferModelCopyWith<$Res> {
  _$SourcingOfferModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SourcingOfferModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? notes = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? farmer = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      farmer: freezed == farmer
          ? _value.farmer
          : farmer // ignore: cast_nullable_to_non_nullable
              as SourcingOfferFarmerModel?,
    ) as $Val);
  }

  /// Create a copy of SourcingOfferModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SourcingOfferFarmerModelCopyWith<$Res>? get farmer {
    if (_value.farmer == null) {
      return null;
    }

    return $SourcingOfferFarmerModelCopyWith<$Res>(_value.farmer!, (value) {
      return _then(_value.copyWith(farmer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SourcingOfferModelImplCopyWith<$Res>
    implements $SourcingOfferModelCopyWith<$Res> {
  factory _$$SourcingOfferModelImplCopyWith(_$SourcingOfferModelImpl value,
          $Res Function(_$SourcingOfferModelImpl) then) =
      __$$SourcingOfferModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      double price,
      String? notes,
      String status,
      @JsonKey(name: 'created_at') DateTime createdAt,
      SourcingOfferFarmerModel? farmer});

  @override
  $SourcingOfferFarmerModelCopyWith<$Res>? get farmer;
}

/// @nodoc
class __$$SourcingOfferModelImplCopyWithImpl<$Res>
    extends _$SourcingOfferModelCopyWithImpl<$Res, _$SourcingOfferModelImpl>
    implements _$$SourcingOfferModelImplCopyWith<$Res> {
  __$$SourcingOfferModelImplCopyWithImpl(_$SourcingOfferModelImpl _value,
      $Res Function(_$SourcingOfferModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SourcingOfferModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? notes = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? farmer = freezed,
  }) {
    return _then(_$SourcingOfferModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      farmer: freezed == farmer
          ? _value.farmer
          : farmer // ignore: cast_nullable_to_non_nullable
              as SourcingOfferFarmerModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SourcingOfferModelImpl implements _SourcingOfferModel {
  const _$SourcingOfferModelImpl(
      {required this.id,
      required this.price,
      this.notes,
      required this.status,
      @JsonKey(name: 'created_at') required this.createdAt,
      this.farmer});

  factory _$SourcingOfferModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SourcingOfferModelImplFromJson(json);

  @override
  final String id;
  @override
  final double price;
  @override
  final String? notes;
  @override
  final String status;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  final SourcingOfferFarmerModel? farmer;

  @override
  String toString() {
    return 'SourcingOfferModel(id: $id, price: $price, notes: $notes, status: $status, createdAt: $createdAt, farmer: $farmer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SourcingOfferModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.farmer, farmer) || other.farmer == farmer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, price, notes, status, createdAt, farmer);

  /// Create a copy of SourcingOfferModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SourcingOfferModelImplCopyWith<_$SourcingOfferModelImpl> get copyWith =>
      __$$SourcingOfferModelImplCopyWithImpl<_$SourcingOfferModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SourcingOfferModelImplToJson(
      this,
    );
  }
}

abstract class _SourcingOfferModel implements SourcingOfferModel {
  const factory _SourcingOfferModel(
      {required final String id,
      required final double price,
      final String? notes,
      required final String status,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      final SourcingOfferFarmerModel? farmer}) = _$SourcingOfferModelImpl;

  factory _SourcingOfferModel.fromJson(Map<String, dynamic> json) =
      _$SourcingOfferModelImpl.fromJson;

  @override
  String get id;
  @override
  double get price;
  @override
  String? get notes;
  @override
  String get status;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  SourcingOfferFarmerModel? get farmer;

  /// Create a copy of SourcingOfferModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SourcingOfferModelImplCopyWith<_$SourcingOfferModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
