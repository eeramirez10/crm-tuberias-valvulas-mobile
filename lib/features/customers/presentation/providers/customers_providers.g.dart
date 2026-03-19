// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customers_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customersDatasourceHash() =>
    r'19515bb73145341695b24a098578885633bd70a1';

/// See also [customersDatasource].
@ProviderFor(customersDatasource)
final customersDatasourceProvider =
    AutoDisposeProvider<CustomersDatasource>.internal(
      customersDatasource,
      name: r'customersDatasourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$customersDatasourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CustomersDatasourceRef = AutoDisposeProviderRef<CustomersDatasource>;
String _$customersRepositoryHash() =>
    r'863afd340059d0e0ac9c0de83e30161f964b69db';

/// See also [customersRepository].
@ProviderFor(customersRepository)
final customersRepositoryProvider =
    AutoDisposeProvider<CustomersRepository>.internal(
      customersRepository,
      name: r'customersRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$customersRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CustomersRepositoryRef = AutoDisposeProviderRef<CustomersRepository>;
String _$getCustomersUseCaseHash() =>
    r'2bee443d293285d156aa0bcef7ffde6afd147d43';

/// See also [getCustomersUseCase].
@ProviderFor(getCustomersUseCase)
final getCustomersUseCaseProvider =
    AutoDisposeProvider<GetCustomersUseCase>.internal(
      getCustomersUseCase,
      name: r'getCustomersUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$getCustomersUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCustomersUseCaseRef = AutoDisposeProviderRef<GetCustomersUseCase>;
String _$customersHash() => r'b5c9f47009c029c3762d31465816310263342166';

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

/// See also [customers].
@ProviderFor(customers)
const customersProvider = CustomersFamily();

/// See also [customers].
class CustomersFamily extends Family<AsyncValue<List<Customer>>> {
  /// See also [customers].
  const CustomersFamily();

  /// See also [customers].
  CustomersProvider call({String? query}) {
    return CustomersProvider(query: query);
  }

  @override
  CustomersProvider getProviderOverride(covariant CustomersProvider provider) {
    return call(query: provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customersProvider';
}

/// See also [customers].
class CustomersProvider extends AutoDisposeFutureProvider<List<Customer>> {
  /// See also [customers].
  CustomersProvider({String? query})
    : this._internal(
        (ref) => customers(ref as CustomersRef, query: query),
        from: customersProvider,
        name: r'customersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$customersHash,
        dependencies: CustomersFamily._dependencies,
        allTransitiveDependencies: CustomersFamily._allTransitiveDependencies,
        query: query,
      );

  CustomersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String? query;

  @override
  Override overrideWith(
    FutureOr<List<Customer>> Function(CustomersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomersProvider._internal(
        (ref) => create(ref as CustomersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Customer>> createElement() {
    return _CustomersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomersProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomersRef on AutoDisposeFutureProviderRef<List<Customer>> {
  /// The parameter `query` of this provider.
  String? get query;
}

class _CustomersProviderElement
    extends AutoDisposeFutureProviderElement<List<Customer>>
    with CustomersRef {
  _CustomersProviderElement(super.provider);

  @override
  String? get query => (origin as CustomersProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
