// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$farmerProductsRepositoryHash() =>
    r'56455677fd52201eb56ce52a20d648352370edd6';

/// See also [farmerProductsRepository].
@ProviderFor(farmerProductsRepository)
final farmerProductsRepositoryProvider =
    AutoDisposeProvider<FarmerProductsRepository>.internal(
  farmerProductsRepository,
  name: r'farmerProductsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$farmerProductsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FarmerProductsRepositoryRef
    = AutoDisposeProviderRef<FarmerProductsRepository>;
String _$getFarmerProductsUseCaseHash() =>
    r'ca929c13aa3c59aa8d1c44d42a49a39748679c3b';

/// See also [getFarmerProductsUseCase].
@ProviderFor(getFarmerProductsUseCase)
final getFarmerProductsUseCaseProvider =
    AutoDisposeProvider<GetFarmerProducts>.internal(
  getFarmerProductsUseCase,
  name: r'getFarmerProductsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getFarmerProductsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetFarmerProductsUseCaseRef = AutoDisposeProviderRef<GetFarmerProducts>;
String _$getFarmerReviewsUseCaseHash() =>
    r'ce60020b9dca7e4ec17d870cfa71129ed40b6fb4';

/// See also [getFarmerReviewsUseCase].
@ProviderFor(getFarmerReviewsUseCase)
final getFarmerReviewsUseCaseProvider =
    AutoDisposeProvider<GetFarmerReviews>.internal(
  getFarmerReviewsUseCase,
  name: r'getFarmerReviewsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getFarmerReviewsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetFarmerReviewsUseCaseRef = AutoDisposeProviderRef<GetFarmerReviews>;
String _$farmerDetailControllerHash() =>
    r'b58efeac2da7086d87c5165055d939194c111e7e';

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

abstract class _$FarmerDetailController
    extends BuildlessAutoDisposeNotifier<FarmerDetailState> {
  late final String farmerId;

  FarmerDetailState build(
    String farmerId,
  );
}

/// See also [FarmerDetailController].
@ProviderFor(FarmerDetailController)
const farmerDetailControllerProvider = FarmerDetailControllerFamily();

/// See also [FarmerDetailController].
class FarmerDetailControllerFamily extends Family<FarmerDetailState> {
  /// See also [FarmerDetailController].
  const FarmerDetailControllerFamily();

  /// See also [FarmerDetailController].
  FarmerDetailControllerProvider call(
    String farmerId,
  ) {
    return FarmerDetailControllerProvider(
      farmerId,
    );
  }

  @override
  FarmerDetailControllerProvider getProviderOverride(
    covariant FarmerDetailControllerProvider provider,
  ) {
    return call(
      provider.farmerId,
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
  String? get name => r'farmerDetailControllerProvider';
}

/// See also [FarmerDetailController].
class FarmerDetailControllerProvider extends AutoDisposeNotifierProviderImpl<
    FarmerDetailController, FarmerDetailState> {
  /// See also [FarmerDetailController].
  FarmerDetailControllerProvider(
    String farmerId,
  ) : this._internal(
          () => FarmerDetailController()..farmerId = farmerId,
          from: farmerDetailControllerProvider,
          name: r'farmerDetailControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$farmerDetailControllerHash,
          dependencies: FarmerDetailControllerFamily._dependencies,
          allTransitiveDependencies:
              FarmerDetailControllerFamily._allTransitiveDependencies,
          farmerId: farmerId,
        );

  FarmerDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.farmerId,
  }) : super.internal();

  final String farmerId;

  @override
  FarmerDetailState runNotifierBuild(
    covariant FarmerDetailController notifier,
  ) {
    return notifier.build(
      farmerId,
    );
  }

  @override
  Override overrideWith(FarmerDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: FarmerDetailControllerProvider._internal(
        () => create()..farmerId = farmerId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        farmerId: farmerId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<FarmerDetailController, FarmerDetailState>
      createElement() {
    return _FarmerDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FarmerDetailControllerProvider &&
        other.farmerId == farmerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, farmerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FarmerDetailControllerRef
    on AutoDisposeNotifierProviderRef<FarmerDetailState> {
  /// The parameter `farmerId` of this provider.
  String get farmerId;
}

class _FarmerDetailControllerProviderElement
    extends AutoDisposeNotifierProviderElement<FarmerDetailController,
        FarmerDetailState> with FarmerDetailControllerRef {
  _FarmerDetailControllerProviderElement(super.provider);

  @override
  String get farmerId => (origin as FarmerDetailControllerProvider).farmerId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
