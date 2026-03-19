// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ordersDatasourceHash() => r'4c2d0947353577565baf78c4bcb4c862e454b0c9';

/// See also [ordersDatasource].
@ProviderFor(ordersDatasource)
final ordersDatasourceProvider = AutoDisposeProvider<OrdersDatasource>.internal(
  ordersDatasource,
  name: r'ordersDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ordersDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrdersDatasourceRef = AutoDisposeProviderRef<OrdersDatasource>;
String _$ordersRepositoryHash() => r'53af2d9e06f88d69dfcc5dacc574218438dfb800';

/// See also [ordersRepository].
@ProviderFor(ordersRepository)
final ordersRepositoryProvider = AutoDisposeProvider<OrdersRepository>.internal(
  ordersRepository,
  name: r'ordersRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ordersRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrdersRepositoryRef = AutoDisposeProviderRef<OrdersRepository>;
String _$getOrdersUseCaseHash() => r'567a76361d95eea138484431d529d7c1214dd7b4';

/// See also [getOrdersUseCase].
@ProviderFor(getOrdersUseCase)
final getOrdersUseCaseProvider = AutoDisposeProvider<GetOrdersUseCase>.internal(
  getOrdersUseCase,
  name: r'getOrdersUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getOrdersUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetOrdersUseCaseRef = AutoDisposeProviderRef<GetOrdersUseCase>;
String _$getOrderByIdUseCaseHash() =>
    r'64d258c75e288025f8af468689ab507d36566f45';

/// See also [getOrderByIdUseCase].
@ProviderFor(getOrderByIdUseCase)
final getOrderByIdUseCaseProvider =
    AutoDisposeProvider<GetOrderByIdUseCase>.internal(
      getOrderByIdUseCase,
      name: r'getOrderByIdUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$getOrderByIdUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetOrderByIdUseCaseRef = AutoDisposeProviderRef<GetOrderByIdUseCase>;
String _$updateOrderStatusUseCaseHash() =>
    r'e233c3d663696a4d420d175e56deffce41b4187b';

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
typedef UpdateOrderStatusUseCaseRef =
    AutoDisposeProviderRef<UpdateOrderStatusUseCase>;
String _$orderDetailsHash() => r'a307ffe5b1c4890bcb526edb5a82321fe6cd1478';

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

/// See also [orderDetails].
@ProviderFor(orderDetails)
const orderDetailsProvider = OrderDetailsFamily();

/// See also [orderDetails].
class OrderDetailsFamily extends Family<AsyncValue<Order>> {
  /// See also [orderDetails].
  const OrderDetailsFamily();

  /// See also [orderDetails].
  OrderDetailsProvider call(String orderId) {
    return OrderDetailsProvider(orderId);
  }

  @override
  OrderDetailsProvider getProviderOverride(
    covariant OrderDetailsProvider provider,
  ) {
    return call(provider.orderId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'orderDetailsProvider';
}

/// See also [orderDetails].
class OrderDetailsProvider extends AutoDisposeFutureProvider<Order> {
  /// See also [orderDetails].
  OrderDetailsProvider(String orderId)
    : this._internal(
        (ref) => orderDetails(ref as OrderDetailsRef, orderId),
        from: orderDetailsProvider,
        name: r'orderDetailsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$orderDetailsHash,
        dependencies: OrderDetailsFamily._dependencies,
        allTransitiveDependencies:
            OrderDetailsFamily._allTransitiveDependencies,
        orderId: orderId,
      );

  OrderDetailsProvider._internal(
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
    FutureOr<Order> Function(OrderDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OrderDetailsProvider._internal(
        (ref) => create(ref as OrderDetailsRef),
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
    return _OrderDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderDetailsProvider && other.orderId == orderId;
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
mixin OrderDetailsRef on AutoDisposeFutureProviderRef<Order> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _OrderDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Order>
    with OrderDetailsRef {
  _OrderDetailsProviderElement(super.provider);

  @override
  String get orderId => (origin as OrderDetailsProvider).orderId;
}

String _$ordersControllerHash() => r'83973b1b64ff8ad06bc7096ec9a085c849cc02e5';

/// See also [OrdersController].
@ProviderFor(OrdersController)
final ordersControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      OrdersController,
      OrdersViewModel
    >.internal(
      OrdersController.new,
      name: r'ordersControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$ordersControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OrdersController = AutoDisposeAsyncNotifier<OrdersViewModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
