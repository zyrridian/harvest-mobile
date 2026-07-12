// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$masterRepositoryHash() => r'f5813d5fafb61270b9ed140448f5268af3015d6e';

/// See also [masterRepository].
@ProviderFor(masterRepository)
final masterRepositoryProvider = AutoDisposeProvider<MasterRepository>.internal(
  masterRepository,
  name: r'masterRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$masterRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MasterRepositoryRef = AutoDisposeProviderRef<MasterRepository>;
String _$provincesHash() => r'c773861a6af311ffedc839e39d3418313814e1f0';

/// See also [provinces].
@ProviderFor(provinces)
final provincesProvider = AutoDisposeFutureProvider<List<Province>>.internal(
  provinces,
  name: r'provincesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$provincesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProvincesRef = AutoDisposeFutureProviderRef<List<Province>>;
String _$citiesHash() => r'5221062dfd480ebe17b671627bdbf5cd2c5f46e6';

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

/// See also [cities].
@ProviderFor(cities)
const citiesProvider = CitiesFamily();

/// See also [cities].
class CitiesFamily extends Family<AsyncValue<List<City>>> {
  /// See also [cities].
  const CitiesFamily();

  /// See also [cities].
  CitiesProvider call(
    int provinceId,
  ) {
    return CitiesProvider(
      provinceId,
    );
  }

  @override
  CitiesProvider getProviderOverride(
    covariant CitiesProvider provider,
  ) {
    return call(
      provider.provinceId,
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
  String? get name => r'citiesProvider';
}

/// See also [cities].
class CitiesProvider extends AutoDisposeFutureProvider<List<City>> {
  /// See also [cities].
  CitiesProvider(
    int provinceId,
  ) : this._internal(
          (ref) => cities(
            ref as CitiesRef,
            provinceId,
          ),
          from: citiesProvider,
          name: r'citiesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$citiesHash,
          dependencies: CitiesFamily._dependencies,
          allTransitiveDependencies: CitiesFamily._allTransitiveDependencies,
          provinceId: provinceId,
        );

  CitiesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.provinceId,
  }) : super.internal();

  final int provinceId;

  @override
  Override overrideWith(
    FutureOr<List<City>> Function(CitiesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CitiesProvider._internal(
        (ref) => create(ref as CitiesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        provinceId: provinceId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<City>> createElement() {
    return _CitiesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CitiesProvider && other.provinceId == provinceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, provinceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CitiesRef on AutoDisposeFutureProviderRef<List<City>> {
  /// The parameter `provinceId` of this provider.
  int get provinceId;
}

class _CitiesProviderElement
    extends AutoDisposeFutureProviderElement<List<City>> with CitiesRef {
  _CitiesProviderElement(super.provider);

  @override
  int get provinceId => (origin as CitiesProvider).provinceId;
}

String _$districtsHash() => r'5cc31a1aa860fedfd6d39e96be7dfcfee595e95c';

/// See also [districts].
@ProviderFor(districts)
const districtsProvider = DistrictsFamily();

/// See also [districts].
class DistrictsFamily extends Family<AsyncValue<List<District>>> {
  /// See also [districts].
  const DistrictsFamily();

  /// See also [districts].
  DistrictsProvider call(
    int cityId,
  ) {
    return DistrictsProvider(
      cityId,
    );
  }

  @override
  DistrictsProvider getProviderOverride(
    covariant DistrictsProvider provider,
  ) {
    return call(
      provider.cityId,
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
  String? get name => r'districtsProvider';
}

/// See also [districts].
class DistrictsProvider extends AutoDisposeFutureProvider<List<District>> {
  /// See also [districts].
  DistrictsProvider(
    int cityId,
  ) : this._internal(
          (ref) => districts(
            ref as DistrictsRef,
            cityId,
          ),
          from: districtsProvider,
          name: r'districtsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$districtsHash,
          dependencies: DistrictsFamily._dependencies,
          allTransitiveDependencies: DistrictsFamily._allTransitiveDependencies,
          cityId: cityId,
        );

  DistrictsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cityId,
  }) : super.internal();

  final int cityId;

  @override
  Override overrideWith(
    FutureOr<List<District>> Function(DistrictsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DistrictsProvider._internal(
        (ref) => create(ref as DistrictsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cityId: cityId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<District>> createElement() {
    return _DistrictsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DistrictsProvider && other.cityId == cityId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cityId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DistrictsRef on AutoDisposeFutureProviderRef<List<District>> {
  /// The parameter `cityId` of this provider.
  int get cityId;
}

class _DistrictsProviderElement
    extends AutoDisposeFutureProviderElement<List<District>> with DistrictsRef {
  _DistrictsProviderElement(super.provider);

  @override
  int get cityId => (origin as DistrictsProvider).cityId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
