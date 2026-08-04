// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productRepositoryHash() => r'1d03735fc66c138acb3359adca05a01005be48dc';

/// See also [productRepository].
@ProviderFor(productRepository)
final productRepositoryProvider =
    AutoDisposeProvider<ProductRepository>.internal(
  productRepository,
  name: r'productRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProductRepositoryRef = AutoDisposeProviderRef<ProductRepository>;
String _$getProductDetailUseCaseHash() =>
    r'c7c945aa6bc7948524aeb6c2a63e382fe49d1dbe';

/// See also [getProductDetailUseCase].
@ProviderFor(getProductDetailUseCase)
final getProductDetailUseCaseProvider =
    AutoDisposeProvider<GetProductDetail>.internal(
  getProductDetailUseCase,
  name: r'getProductDetailUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getProductDetailUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetProductDetailUseCaseRef = AutoDisposeProviderRef<GetProductDetail>;
String _$checkFavoriteStatusUseCaseHash() =>
    r'af22ae1f772dd860dea43fabdfe1593ee849b164';

/// See also [checkFavoriteStatusUseCase].
@ProviderFor(checkFavoriteStatusUseCase)
final checkFavoriteStatusUseCaseProvider =
    AutoDisposeProvider<CheckFavoriteStatus>.internal(
  checkFavoriteStatusUseCase,
  name: r'checkFavoriteStatusUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$checkFavoriteStatusUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CheckFavoriteStatusUseCaseRef
    = AutoDisposeProviderRef<CheckFavoriteStatus>;
String _$addFavoriteUseCaseHash() =>
    r'01a96e521697ed3598673b598a623dd074b84da0';

/// See also [addFavoriteUseCase].
@ProviderFor(addFavoriteUseCase)
final addFavoriteUseCaseProvider =
    AutoDisposeProvider<AddFavoriteUseCase>.internal(
  addFavoriteUseCase,
  name: r'addFavoriteUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addFavoriteUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddFavoriteUseCaseRef = AutoDisposeProviderRef<AddFavoriteUseCase>;
String _$removeFavoriteUseCaseHash() =>
    r'a5d02aac1261d93979f18827590319051785fd2a';

/// See also [removeFavoriteUseCase].
@ProviderFor(removeFavoriteUseCase)
final removeFavoriteUseCaseProvider =
    AutoDisposeProvider<RemoveFavoriteUseCase>.internal(
  removeFavoriteUseCase,
  name: r'removeFavoriteUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$removeFavoriteUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RemoveFavoriteUseCaseRef
    = AutoDisposeProviderRef<RemoveFavoriteUseCase>;
String _$submitProductReviewUseCaseHash() =>
    r'1e22ef546d586aeaded9d09262d76f0ead45586c';

/// See also [submitProductReviewUseCase].
@ProviderFor(submitProductReviewUseCase)
final submitProductReviewUseCaseProvider =
    AutoDisposeProvider<SubmitProductReview>.internal(
  submitProductReviewUseCase,
  name: r'submitProductReviewUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$submitProductReviewUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubmitProductReviewUseCaseRef
    = AutoDisposeProviderRef<SubmitProductReview>;
String _$getProductReviewsUseCaseHash() =>
    r'375ac7f120638d2bad0575b5216f35367c8117df';

/// See also [getProductReviewsUseCase].
@ProviderFor(getProductReviewsUseCase)
final getProductReviewsUseCaseProvider =
    AutoDisposeProvider<GetProductReviews>.internal(
  getProductReviewsUseCase,
  name: r'getProductReviewsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getProductReviewsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetProductReviewsUseCaseRef = AutoDisposeProviderRef<GetProductReviews>;
String _$productReviewsHash() => r'a19f8d5d2ce53d5717c42bb4ed246df931f6b9d9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [productReviews].
@ProviderFor(productReviews)
const productReviewsProvider = ProductReviewsFamily();

/// See also [productReviews].
class ProductReviewsFamily extends Family<AsyncValue<ReviewResponse>> {
  /// See also [productReviews].
  const ProductReviewsFamily();

  /// See also [productReviews].
  ProductReviewsProvider call(
    String slug,
  ) {
    return ProductReviewsProvider(
      slug,
    );
  }

  @override
  ProductReviewsProvider getProviderOverride(
    covariant ProductReviewsProvider provider,
  ) {
    return call(
      provider.slug,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productReviewsProvider';
}

/// See also [productReviews].
class ProductReviewsProvider extends AutoDisposeFutureProvider<ReviewResponse> {
  /// See also [productReviews].
  ProductReviewsProvider(
    String slug,
  ) : this._internal(
          (ref) => productReviews(
            ref as ProductReviewsRef,
            slug,
          ),
          from: productReviewsProvider,
          name: r'productReviewsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productReviewsHash,
          dependencies: ProductReviewsFamily._dependencies,
          allTransitiveDependencies:
              ProductReviewsFamily._allTransitiveDependencies,
          slug: slug,
        );

  ProductReviewsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.slug,
  }) : super.internal();

  final String slug;

  @override
  Override overrideWith(
    FutureOr<ReviewResponse> Function(ProductReviewsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductReviewsProvider._internal(
        (ref) => create(ref as ProductReviewsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        slug: slug,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ReviewResponse> createElement() {
    return _ProductReviewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductReviewsProvider && other.slug == slug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductReviewsRef on AutoDisposeFutureProviderRef<ReviewResponse> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _ProductReviewsProviderElement
    extends AutoDisposeFutureProviderElement<ReviewResponse>
    with ProductReviewsRef {
  _ProductReviewsProviderElement(super.provider);

  @override
  String get slug => (origin as ProductReviewsProvider).slug;
}

String _$productDetailControllerHash() =>
    r'36f9bf5d172d87e9c0cd428175ce398a461d0a5e';

abstract class _$ProductDetailController
    extends BuildlessAutoDisposeNotifier<ProductDetailState> {
  late final String slug;

  ProductDetailState build(
    String slug,
  );
}

/// See also [ProductDetailController].
@ProviderFor(ProductDetailController)
const productDetailControllerProvider = ProductDetailControllerFamily();

/// See also [ProductDetailController].
class ProductDetailControllerFamily extends Family<ProductDetailState> {
  /// See also [ProductDetailController].
  const ProductDetailControllerFamily();

  /// See also [ProductDetailController].
  ProductDetailControllerProvider call(
    String slug,
  ) {
    return ProductDetailControllerProvider(
      slug,
    );
  }

  @override
  ProductDetailControllerProvider getProviderOverride(
    covariant ProductDetailControllerProvider provider,
  ) {
    return call(
      provider.slug,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productDetailControllerProvider';
}

/// See also [ProductDetailController].
class ProductDetailControllerProvider extends AutoDisposeNotifierProviderImpl<
    ProductDetailController, ProductDetailState> {
  /// See also [ProductDetailController].
  ProductDetailControllerProvider(
    String slug,
  ) : this._internal(
          () => ProductDetailController()..slug = slug,
          from: productDetailControllerProvider,
          name: r'productDetailControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productDetailControllerHash,
          dependencies: ProductDetailControllerFamily._dependencies,
          allTransitiveDependencies:
              ProductDetailControllerFamily._allTransitiveDependencies,
          slug: slug,
        );

  ProductDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.slug,
  }) : super.internal();

  final String slug;

  @override
  ProductDetailState runNotifierBuild(
    covariant ProductDetailController notifier,
  ) {
    return notifier.build(
      slug,
    );
  }

  @override
  Override overrideWith(ProductDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductDetailControllerProvider._internal(
        () => create()..slug = slug,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        slug: slug,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ProductDetailController,
      ProductDetailState> createElement() {
    return _ProductDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailControllerProvider && other.slug == slug;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, slug.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductDetailControllerRef
    on AutoDisposeNotifierProviderRef<ProductDetailState> {
  /// The parameter `slug` of this provider.
  String get slug;
}

class _ProductDetailControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ProductDetailController,
        ProductDetailState> with ProductDetailControllerRef {
  _ProductDetailControllerProviderElement(super.provider);

  @override
  String get slug => (origin as ProductDetailControllerProvider).slug;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
