// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farmer_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FarmerDetailState {
  AsyncValue<List<Product>> get products => throw _privateConstructorUsedError;
  AsyncValue<List<CommunityPost>> get posts =>
      throw _privateConstructorUsedError;
  AsyncValue<List<Review>> get reviews => throw _privateConstructorUsedError;

  /// Create a copy of FarmerDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FarmerDetailStateCopyWith<FarmerDetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FarmerDetailStateCopyWith<$Res> {
  factory $FarmerDetailStateCopyWith(
          FarmerDetailState value, $Res Function(FarmerDetailState) then) =
      _$FarmerDetailStateCopyWithImpl<$Res, FarmerDetailState>;
  @useResult
  $Res call(
      {AsyncValue<List<Product>> products,
      AsyncValue<List<CommunityPost>> posts,
      AsyncValue<List<Review>> reviews});
}

/// @nodoc
class _$FarmerDetailStateCopyWithImpl<$Res, $Val extends FarmerDetailState>
    implements $FarmerDetailStateCopyWith<$Res> {
  _$FarmerDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FarmerDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? posts = null,
    Object? reviews = null,
  }) {
    return _then(_value.copyWith(
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as AsyncValue<List<Product>>,
      posts: null == posts
          ? _value.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as AsyncValue<List<CommunityPost>>,
      reviews: null == reviews
          ? _value.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as AsyncValue<List<Review>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FarmerDetailStateImplCopyWith<$Res>
    implements $FarmerDetailStateCopyWith<$Res> {
  factory _$$FarmerDetailStateImplCopyWith(_$FarmerDetailStateImpl value,
          $Res Function(_$FarmerDetailStateImpl) then) =
      __$$FarmerDetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AsyncValue<List<Product>> products,
      AsyncValue<List<CommunityPost>> posts,
      AsyncValue<List<Review>> reviews});
}

/// @nodoc
class __$$FarmerDetailStateImplCopyWithImpl<$Res>
    extends _$FarmerDetailStateCopyWithImpl<$Res, _$FarmerDetailStateImpl>
    implements _$$FarmerDetailStateImplCopyWith<$Res> {
  __$$FarmerDetailStateImplCopyWithImpl(_$FarmerDetailStateImpl _value,
      $Res Function(_$FarmerDetailStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FarmerDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? posts = null,
    Object? reviews = null,
  }) {
    return _then(_$FarmerDetailStateImpl(
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as AsyncValue<List<Product>>,
      posts: null == posts
          ? _value.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as AsyncValue<List<CommunityPost>>,
      reviews: null == reviews
          ? _value.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as AsyncValue<List<Review>>,
    ));
  }
}

/// @nodoc

class _$FarmerDetailStateImpl implements _FarmerDetailState {
  const _$FarmerDetailStateImpl(
      {this.products = const AsyncValue.loading(),
      this.posts = const AsyncValue.loading(),
      this.reviews = const AsyncValue.loading()});

  @override
  @JsonKey()
  final AsyncValue<List<Product>> products;
  @override
  @JsonKey()
  final AsyncValue<List<CommunityPost>> posts;
  @override
  @JsonKey()
  final AsyncValue<List<Review>> reviews;

  @override
  String toString() {
    return 'FarmerDetailState(products: $products, posts: $posts, reviews: $reviews)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FarmerDetailStateImpl &&
            (identical(other.products, products) ||
                other.products == products) &&
            (identical(other.posts, posts) || other.posts == posts) &&
            (identical(other.reviews, reviews) || other.reviews == reviews));
  }

  @override
  int get hashCode => Object.hash(runtimeType, products, posts, reviews);

  /// Create a copy of FarmerDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FarmerDetailStateImplCopyWith<_$FarmerDetailStateImpl> get copyWith =>
      __$$FarmerDetailStateImplCopyWithImpl<_$FarmerDetailStateImpl>(
          this, _$identity);
}

abstract class _FarmerDetailState implements FarmerDetailState {
  const factory _FarmerDetailState(
      {final AsyncValue<List<Product>> products,
      final AsyncValue<List<CommunityPost>> posts,
      final AsyncValue<List<Review>> reviews}) = _$FarmerDetailStateImpl;

  @override
  AsyncValue<List<Product>> get products;
  @override
  AsyncValue<List<CommunityPost>> get posts;
  @override
  AsyncValue<List<Review>> get reviews;

  /// Create a copy of FarmerDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FarmerDetailStateImplCopyWith<_$FarmerDetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
