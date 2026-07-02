// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderRepositoryHash() => r'bfe89625e995c22ad87ac53c980eb03af81d5a12';

/// See also [orderRepository].
@ProviderFor(orderRepository)
final orderRepositoryProvider = AutoDisposeProvider<OrderRepository>.internal(
  orderRepository,
  name: r'orderRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrderRepositoryRef = AutoDisposeProviderRef<OrderRepository>;
String _$getOrdersUsecaseHash() => r'7c5fdbd83efb71383668226d484c58ec7b5c3e32';

/// See also [getOrdersUsecase].
@ProviderFor(getOrdersUsecase)
final getOrdersUsecaseProvider = AutoDisposeProvider<GetOrders>.internal(
  getOrdersUsecase,
  name: r'getOrdersUsecaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getOrdersUsecaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetOrdersUsecaseRef = AutoDisposeProviderRef<GetOrders>;
String _$getOrderDetailUsecaseHash() =>
    r'808edb9cf634ee3c982e586d3913012ab1290b1b';

/// See also [getOrderDetailUsecase].
@ProviderFor(getOrderDetailUsecase)
final getOrderDetailUsecaseProvider =
    AutoDisposeProvider<GetOrderDetail>.internal(
  getOrderDetailUsecase,
  name: r'getOrderDetailUsecaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getOrderDetailUsecaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetOrderDetailUsecaseRef = AutoDisposeProviderRef<GetOrderDetail>;
String _$createOrderUsecaseHash() =>
    r'768e0a19d914bae14071b754c3f5a172ff6de8d9';

/// See also [createOrderUsecase].
@ProviderFor(createOrderUsecase)
final createOrderUsecaseProvider = AutoDisposeProvider<CreateOrder>.internal(
  createOrderUsecase,
  name: r'createOrderUsecaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createOrderUsecaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateOrderUsecaseRef = AutoDisposeProviderRef<CreateOrder>;
String _$cancelOrderUsecaseHash() =>
    r'170b3eb9ac795a547fdb882ab6ca51b3ed9cdbfa';

/// See also [cancelOrderUsecase].
@ProviderFor(cancelOrderUsecase)
final cancelOrderUsecaseProvider = AutoDisposeProvider<CancelOrder>.internal(
  cancelOrderUsecase,
  name: r'cancelOrderUsecaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cancelOrderUsecaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CancelOrderUsecaseRef = AutoDisposeProviderRef<CancelOrder>;
String _$ordersHash() => r'56cea2deb7a9293dbfaa0f9619861fa459b6af21';

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

/// See also [orders].
@ProviderFor(orders)
const ordersProvider = OrdersFamily();

/// See also [orders].
class OrdersFamily extends Family<AsyncValue<List<Order>>> {
  /// See also [orders].
  const OrdersFamily();

  /// See also [orders].
  OrdersProvider call(
    Map<String, dynamic> params,
  ) {
    return OrdersProvider(
      params,
    );
  }

  @override
  OrdersProvider getProviderOverride(
    covariant OrdersProvider provider,
  ) {
    return call(
      provider.params,
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
  String? get name => r'ordersProvider';
}

/// See also [orders].
class OrdersProvider extends AutoDisposeFutureProvider<List<Order>> {
  /// See also [orders].
  OrdersProvider(
    Map<String, dynamic> params,
  ) : this._internal(
          (ref) => orders(
            ref as OrdersRef,
            params,
          ),
          from: ordersProvider,
          name: r'ordersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ordersHash,
          dependencies: OrdersFamily._dependencies,
          allTransitiveDependencies: OrdersFamily._allTransitiveDependencies,
          params: params,
        );

  OrdersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final Map<String, dynamic> params;

  @override
  Override overrideWith(
    FutureOr<List<Order>> Function(OrdersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OrdersProvider._internal(
        (ref) => create(ref as OrdersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Order>> createElement() {
    return _OrdersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrdersProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrdersRef on AutoDisposeFutureProviderRef<List<Order>> {
  /// The parameter `params` of this provider.
  Map<String, dynamic> get params;
}

class _OrdersProviderElement
    extends AutoDisposeFutureProviderElement<List<Order>> with OrdersRef {
  _OrdersProviderElement(super.provider);

  @override
  Map<String, dynamic> get params => (origin as OrdersProvider).params;
}

String _$orderDetailHash() => r'0c053a2b149ab84a4385e4a5507b094b2795dac8';

/// See also [orderDetail].
@ProviderFor(orderDetail)
const orderDetailProvider = OrderDetailFamily();

/// See also [orderDetail].
class OrderDetailFamily extends Family<AsyncValue<Order>> {
  /// See also [orderDetail].
  const OrderDetailFamily();

  /// See also [orderDetail].
  OrderDetailProvider call(
    String orderId,
  ) {
    return OrderDetailProvider(
      orderId,
    );
  }

  @override
  OrderDetailProvider getProviderOverride(
    covariant OrderDetailProvider provider,
  ) {
    return call(
      provider.orderId,
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
  String? get name => r'orderDetailProvider';
}

/// See also [orderDetail].
class OrderDetailProvider extends AutoDisposeFutureProvider<Order> {
  /// See also [orderDetail].
  OrderDetailProvider(
    String orderId,
  ) : this._internal(
          (ref) => orderDetail(
            ref as OrderDetailRef,
            orderId,
          ),
          from: orderDetailProvider,
          name: r'orderDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$orderDetailHash,
          dependencies: OrderDetailFamily._dependencies,
          allTransitiveDependencies:
              OrderDetailFamily._allTransitiveDependencies,
          orderId: orderId,
        );

  OrderDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final String orderId;

  @override
  Override overrideWith(
    FutureOr<Order> Function(OrderDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OrderDetailProvider._internal(
        (ref) => create(ref as OrderDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Order> createElement() {
    return _OrderDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderDetailProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrderDetailRef on AutoDisposeFutureProviderRef<Order> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _OrderDetailProviderElement
    extends AutoDisposeFutureProviderElement<Order> with OrderDetailRef {
  _OrderDetailProviderElement(super.provider);

  @override
  String get orderId => (origin as OrderDetailProvider).orderId;
}

String _$orderControllerHash() => r'd02cfa4e09997e26820dab2b4f4ba31dc5a62df9';

/// See also [OrderController].
@ProviderFor(OrderController)
final orderControllerProvider =
    AutoDisposeNotifierProvider<OrderController, OrderState>.internal(
  OrderController.new,
  name: r'orderControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OrderController = AutoDisposeNotifier<OrderState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
