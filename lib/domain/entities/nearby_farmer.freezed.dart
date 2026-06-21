// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nearby_farmer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NearbyFarmerProduct _$NearbyFarmerProductFromJson(Map<String, dynamic> json) {
  return _NearbyFarmerProduct.fromJson(json);
}

/// @nodoc
mixin _$NearbyFarmerProduct {
  String get name => throw _privateConstructorUsedError;

  /// Serializes this NearbyFarmerProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NearbyFarmerProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NearbyFarmerProductCopyWith<NearbyFarmerProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NearbyFarmerProductCopyWith<$Res> {
  factory $NearbyFarmerProductCopyWith(
          NearbyFarmerProduct value, $Res Function(NearbyFarmerProduct) then) =
      _$NearbyFarmerProductCopyWithImpl<$Res, NearbyFarmerProduct>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$NearbyFarmerProductCopyWithImpl<$Res, $Val extends NearbyFarmerProduct>
    implements $NearbyFarmerProductCopyWith<$Res> {
  _$NearbyFarmerProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NearbyFarmerProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NearbyFarmerProductImplCopyWith<$Res>
    implements $NearbyFarmerProductCopyWith<$Res> {
  factory _$$NearbyFarmerProductImplCopyWith(_$NearbyFarmerProductImpl value,
          $Res Function(_$NearbyFarmerProductImpl) then) =
      __$$NearbyFarmerProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$NearbyFarmerProductImplCopyWithImpl<$Res>
    extends _$NearbyFarmerProductCopyWithImpl<$Res, _$NearbyFarmerProductImpl>
    implements _$$NearbyFarmerProductImplCopyWith<$Res> {
  __$$NearbyFarmerProductImplCopyWithImpl(_$NearbyFarmerProductImpl _value,
      $Res Function(_$NearbyFarmerProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of NearbyFarmerProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$NearbyFarmerProductImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NearbyFarmerProductImpl implements _NearbyFarmerProduct {
  const _$NearbyFarmerProductImpl({required this.name});

  factory _$NearbyFarmerProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$NearbyFarmerProductImplFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'NearbyFarmerProduct(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearbyFarmerProductImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of NearbyFarmerProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NearbyFarmerProductImplCopyWith<_$NearbyFarmerProductImpl> get copyWith =>
      __$$NearbyFarmerProductImplCopyWithImpl<_$NearbyFarmerProductImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NearbyFarmerProductImplToJson(
      this,
    );
  }
}

abstract class _NearbyFarmerProduct implements NearbyFarmerProduct {
  const factory _NearbyFarmerProduct({required final String name}) =
      _$NearbyFarmerProductImpl;

  factory _NearbyFarmerProduct.fromJson(Map<String, dynamic> json) =
      _$NearbyFarmerProductImpl.fromJson;

  @override
  String get name;

  /// Create a copy of NearbyFarmerProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NearbyFarmerProductImplCopyWith<_$NearbyFarmerProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NearbyFarmerData _$NearbyFarmerDataFromJson(Map<String, dynamic> json) {
  return _NearbyFarmerData.fromJson(json);
}

/// @nodoc
mixin _$NearbyFarmerData {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get subCategory => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<NearbyFarmerProduct> get products => throw _privateConstructorUsedError;
  int get extraProductsCount => throw _privateConstructorUsedError;
  String get statusText => throw _privateConstructorUsedError;
  String get statusSubText => throw _privateConstructorUsedError;
  bool get isOpen => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get iconPath => throw _privateConstructorUsedError;

  /// Serializes this NearbyFarmerData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NearbyFarmerData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NearbyFarmerDataCopyWith<NearbyFarmerData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NearbyFarmerDataCopyWith<$Res> {
  factory $NearbyFarmerDataCopyWith(
          NearbyFarmerData value, $Res Function(NearbyFarmerData) then) =
      _$NearbyFarmerDataCopyWithImpl<$Res, NearbyFarmerData>;
  @useResult
  $Res call(
      {String id,
      String name,
      double distance,
      String category,
      String subCategory,
      double rating,
      int reviewCount,
      List<String> tags,
      List<NearbyFarmerProduct> products,
      int extraProductsCount,
      String statusText,
      String statusSubText,
      bool isOpen,
      double latitude,
      double longitude,
      String iconPath});
}

/// @nodoc
class _$NearbyFarmerDataCopyWithImpl<$Res, $Val extends NearbyFarmerData>
    implements $NearbyFarmerDataCopyWith<$Res> {
  _$NearbyFarmerDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NearbyFarmerData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? distance = null,
    Object? category = null,
    Object? subCategory = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? tags = null,
    Object? products = null,
    Object? extraProductsCount = null,
    Object? statusText = null,
    Object? statusSubText = null,
    Object? isOpen = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? iconPath = null,
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
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      subCategory: null == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<NearbyFarmerProduct>,
      extraProductsCount: null == extraProductsCount
          ? _value.extraProductsCount
          : extraProductsCount // ignore: cast_nullable_to_non_nullable
              as int,
      statusText: null == statusText
          ? _value.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String,
      statusSubText: null == statusSubText
          ? _value.statusSubText
          : statusSubText // ignore: cast_nullable_to_non_nullable
              as String,
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      iconPath: null == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NearbyFarmerDataImplCopyWith<$Res>
    implements $NearbyFarmerDataCopyWith<$Res> {
  factory _$$NearbyFarmerDataImplCopyWith(_$NearbyFarmerDataImpl value,
          $Res Function(_$NearbyFarmerDataImpl) then) =
      __$$NearbyFarmerDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double distance,
      String category,
      String subCategory,
      double rating,
      int reviewCount,
      List<String> tags,
      List<NearbyFarmerProduct> products,
      int extraProductsCount,
      String statusText,
      String statusSubText,
      bool isOpen,
      double latitude,
      double longitude,
      String iconPath});
}

/// @nodoc
class __$$NearbyFarmerDataImplCopyWithImpl<$Res>
    extends _$NearbyFarmerDataCopyWithImpl<$Res, _$NearbyFarmerDataImpl>
    implements _$$NearbyFarmerDataImplCopyWith<$Res> {
  __$$NearbyFarmerDataImplCopyWithImpl(_$NearbyFarmerDataImpl _value,
      $Res Function(_$NearbyFarmerDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of NearbyFarmerData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? distance = null,
    Object? category = null,
    Object? subCategory = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? tags = null,
    Object? products = null,
    Object? extraProductsCount = null,
    Object? statusText = null,
    Object? statusSubText = null,
    Object? isOpen = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? iconPath = null,
  }) {
    return _then(_$NearbyFarmerDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      subCategory: null == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      products: null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<NearbyFarmerProduct>,
      extraProductsCount: null == extraProductsCount
          ? _value.extraProductsCount
          : extraProductsCount // ignore: cast_nullable_to_non_nullable
              as int,
      statusText: null == statusText
          ? _value.statusText
          : statusText // ignore: cast_nullable_to_non_nullable
              as String,
      statusSubText: null == statusSubText
          ? _value.statusSubText
          : statusSubText // ignore: cast_nullable_to_non_nullable
              as String,
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      iconPath: null == iconPath
          ? _value.iconPath
          : iconPath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NearbyFarmerDataImpl implements _NearbyFarmerData {
  const _$NearbyFarmerDataImpl(
      {required this.id,
      required this.name,
      required this.distance,
      required this.category,
      required this.subCategory,
      required this.rating,
      required this.reviewCount,
      required final List<String> tags,
      required final List<NearbyFarmerProduct> products,
      required this.extraProductsCount,
      required this.statusText,
      required this.statusSubText,
      required this.isOpen,
      required this.latitude,
      required this.longitude,
      required this.iconPath})
      : _tags = tags,
        _products = products;

  factory _$NearbyFarmerDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$NearbyFarmerDataImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double distance;
  @override
  final String category;
  @override
  final String subCategory;
  @override
  final double rating;
  @override
  final int reviewCount;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<NearbyFarmerProduct> _products;
  @override
  List<NearbyFarmerProduct> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  final int extraProductsCount;
  @override
  final String statusText;
  @override
  final String statusSubText;
  @override
  final bool isOpen;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String iconPath;

  @override
  String toString() {
    return 'NearbyFarmerData(id: $id, name: $name, distance: $distance, category: $category, subCategory: $subCategory, rating: $rating, reviewCount: $reviewCount, tags: $tags, products: $products, extraProductsCount: $extraProductsCount, statusText: $statusText, statusSubText: $statusSubText, isOpen: $isOpen, latitude: $latitude, longitude: $longitude, iconPath: $iconPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearbyFarmerDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subCategory, subCategory) ||
                other.subCategory == subCategory) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.extraProductsCount, extraProductsCount) ||
                other.extraProductsCount == extraProductsCount) &&
            (identical(other.statusText, statusText) ||
                other.statusText == statusText) &&
            (identical(other.statusSubText, statusSubText) ||
                other.statusSubText == statusSubText) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.iconPath, iconPath) ||
                other.iconPath == iconPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      distance,
      category,
      subCategory,
      rating,
      reviewCount,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_products),
      extraProductsCount,
      statusText,
      statusSubText,
      isOpen,
      latitude,
      longitude,
      iconPath);

  /// Create a copy of NearbyFarmerData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NearbyFarmerDataImplCopyWith<_$NearbyFarmerDataImpl> get copyWith =>
      __$$NearbyFarmerDataImplCopyWithImpl<_$NearbyFarmerDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NearbyFarmerDataImplToJson(
      this,
    );
  }
}

abstract class _NearbyFarmerData implements NearbyFarmerData {
  const factory _NearbyFarmerData(
      {required final String id,
      required final String name,
      required final double distance,
      required final String category,
      required final String subCategory,
      required final double rating,
      required final int reviewCount,
      required final List<String> tags,
      required final List<NearbyFarmerProduct> products,
      required final int extraProductsCount,
      required final String statusText,
      required final String statusSubText,
      required final bool isOpen,
      required final double latitude,
      required final double longitude,
      required final String iconPath}) = _$NearbyFarmerDataImpl;

  factory _NearbyFarmerData.fromJson(Map<String, dynamic> json) =
      _$NearbyFarmerDataImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get distance;
  @override
  String get category;
  @override
  String get subCategory;
  @override
  double get rating;
  @override
  int get reviewCount;
  @override
  List<String> get tags;
  @override
  List<NearbyFarmerProduct> get products;
  @override
  int get extraProductsCount;
  @override
  String get statusText;
  @override
  String get statusSubText;
  @override
  bool get isOpen;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get iconPath;

  /// Create a copy of NearbyFarmerData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NearbyFarmerDataImplCopyWith<_$NearbyFarmerDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
