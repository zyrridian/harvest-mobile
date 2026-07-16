// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farmer_orders_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getFarmerOrdersUseCaseHash() =>
    r'4f27364b44e7f564f4f6d3c9c0178ad4e6ef8f62';

/// See also [getFarmerOrdersUseCase].
@ProviderFor(getFarmerOrdersUseCase)
final getFarmerOrdersUseCaseProvider =
    AutoDisposeProvider<GetFarmerOrdersUseCase>.internal(
  getFarmerOrdersUseCase,
  name: r'getFarmerOrdersUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getFarmerOrdersUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetFarmerOrdersUseCaseRef
    = AutoDisposeProviderRef<GetFarmerOrdersUseCase>;
String _$updateOrderStatusUseCaseHash() =>
    r'c0f8b6879a7fda7a1ab7c54070462d3f5cea64b0';

/// See also [updateOrderStatusUseCase].
@ProviderFor(updateOrderStatusUseCase)
final updateOrderStatusUseCaseProvider =
    AutoDisposeProvider<UpdateOrderStatusUseCase>.internal(
  updateOrderStatusUseCase,
  name: r'updateOrderStatusUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateOrderStatusUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateOrderStatusUseCaseRef
    = AutoDisposeProviderRef<UpdateOrderStatusUseCase>;
String _$farmerOrdersControllerHash() =>
    r'788e92c344379544e1cfc2d4988768648cb2f216';

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

abstract class _$FarmerOrdersController
    extends BuildlessAutoDisposeNotifier<FarmerOrdersState> {
  late final String status;

  FarmerOrdersState build({
    String status = 'all',
  });
}

/// See also [FarmerOrdersController].
@ProviderFor(FarmerOrdersController)
const farmerOrdersControllerProvider = FarmerOrdersControllerFamily();

/// See also [FarmerOrdersController].
class FarmerOrdersControllerFamily extends Family<FarmerOrdersState> {
  /// See also [FarmerOrdersController].
  const FarmerOrdersControllerFamily();

  /// See also [FarmerOrdersController].
  FarmerOrdersControllerProvider call({
    String status = 'all',
  }) {
    return FarmerOrdersControllerProvider(
      status: status,
    );
  }

  @override
  FarmerOrdersControllerProvider getProviderOverride(
    covariant FarmerOrdersControllerProvider provider,
  ) {
    return call(
      status: provider.status,
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
  String? get name => r'farmerOrdersControllerProvider';
}

/// See also [FarmerOrdersController].
class FarmerOrdersControllerProvider extends AutoDisposeNotifierProviderImpl<
    FarmerOrdersController, FarmerOrdersState> {
  /// See also [FarmerOrdersController].
  FarmerOrdersControllerProvider({
    String status = 'all',
  }) : this._internal(
          () => FarmerOrdersController()..status = status,
          from: farmerOrdersControllerProvider,
          name: r'farmerOrdersControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$farmerOrdersControllerHash,
          dependencies: FarmerOrdersControllerFamily._dependencies,
          allTransitiveDependencies:
              FarmerOrdersControllerFamily._allTransitiveDependencies,
          status: status,
        );

  FarmerOrdersControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String status;

  @override
  FarmerOrdersState runNotifierBuild(
    covariant FarmerOrdersController notifier,
  ) {
    return notifier.build(
      status: status,
    );
  }

  @override
  Override overrideWith(FarmerOrdersController Function() create) {
    return ProviderOverride(
      origin: this,
      override: FarmerOrdersControllerProvider._internal(
        () => create()..status = status,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<FarmerOrdersController, FarmerOrdersState>
      createElement() {
    return _FarmerOrdersControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FarmerOrdersControllerProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FarmerOrdersControllerRef
    on AutoDisposeNotifierProviderRef<FarmerOrdersState> {
  /// The parameter `status` of this provider.
  String get status;
}

class _FarmerOrdersControllerProviderElement
    extends AutoDisposeNotifierProviderElement<FarmerOrdersController,
        FarmerOrdersState> with FarmerOrdersControllerRef {
  _FarmerOrdersControllerProviderElement(super.provider);

  @override
  String get status => (origin as FarmerOrdersControllerProvider).status;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
