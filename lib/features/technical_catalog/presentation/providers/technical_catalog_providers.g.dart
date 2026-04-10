// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technical_catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$technicalCatalogDatasourceHash() =>
    r'25cada92bf0eea5e8bbee71487eb0662e8720189';

/// See also [technicalCatalogDatasource].
@ProviderFor(technicalCatalogDatasource)
final technicalCatalogDatasourceProvider =
    AutoDisposeProvider<TechnicalCatalogDatasource>.internal(
      technicalCatalogDatasource,
      name: r'technicalCatalogDatasourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$technicalCatalogDatasourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TechnicalCatalogDatasourceRef =
    AutoDisposeProviderRef<TechnicalCatalogDatasource>;
String _$technicalCatalogRepositoryHash() =>
    r'95930e9dfc7b748e32029fb2a87451742c519f90';

/// See also [technicalCatalogRepository].
@ProviderFor(technicalCatalogRepository)
final technicalCatalogRepositoryProvider =
    AutoDisposeProvider<TechnicalCatalogRepository>.internal(
      technicalCatalogRepository,
      name: r'technicalCatalogRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$technicalCatalogRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TechnicalCatalogRepositoryRef =
    AutoDisposeProviderRef<TechnicalCatalogRepository>;
String _$getCatalogProductsUseCaseHash() =>
    r'0104c523a46a309f971f7a219fb9cbb8a0841622';

/// See also [getCatalogProductsUseCase].
@ProviderFor(getCatalogProductsUseCase)
final getCatalogProductsUseCaseProvider =
    AutoDisposeProvider<GetCatalogProductsUseCase>.internal(
      getCatalogProductsUseCase,
      name: r'getCatalogProductsUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$getCatalogProductsUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCatalogProductsUseCaseRef =
    AutoDisposeProviderRef<GetCatalogProductsUseCase>;
String _$getCatalogDatasheetsUseCaseHash() =>
    r'7caef23f89cee221246a25da6e9ddaaa191b1b0e';

/// See also [getCatalogDatasheetsUseCase].
@ProviderFor(getCatalogDatasheetsUseCase)
final getCatalogDatasheetsUseCaseProvider =
    AutoDisposeProvider<GetCatalogDatasheetsUseCase>.internal(
      getCatalogDatasheetsUseCase,
      name: r'getCatalogDatasheetsUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$getCatalogDatasheetsUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCatalogDatasheetsUseCaseRef =
    AutoDisposeProviderRef<GetCatalogDatasheetsUseCase>;
String _$technicalCatalogProductsHash() =>
    r'93309b6eb24da659e715ef2639c311d8e762da8d';

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

/// See also [technicalCatalogProducts].
@ProviderFor(technicalCatalogProducts)
const technicalCatalogProductsProvider = TechnicalCatalogProductsFamily();

/// See also [technicalCatalogProducts].
class TechnicalCatalogProductsFamily
    extends Family<AsyncValue<List<CatalogProduct>>> {
  /// See also [technicalCatalogProducts].
  const TechnicalCatalogProductsFamily();

  /// See also [technicalCatalogProducts].
  TechnicalCatalogProductsProvider call({
    String? material,
    String? valveType,
    String? standard,
    String? productType,
  }) {
    return TechnicalCatalogProductsProvider(
      material: material,
      valveType: valveType,
      standard: standard,
      productType: productType,
    );
  }

  @override
  TechnicalCatalogProductsProvider getProviderOverride(
    covariant TechnicalCatalogProductsProvider provider,
  ) {
    return call(
      material: provider.material,
      valveType: provider.valveType,
      standard: provider.standard,
      productType: provider.productType,
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
  String? get name => r'technicalCatalogProductsProvider';
}

/// See also [technicalCatalogProducts].
class TechnicalCatalogProductsProvider
    extends AutoDisposeFutureProvider<List<CatalogProduct>> {
  /// See also [technicalCatalogProducts].
  TechnicalCatalogProductsProvider({
    String? material,
    String? valveType,
    String? standard,
    String? productType,
  }) : this._internal(
         (ref) => technicalCatalogProducts(
           ref as TechnicalCatalogProductsRef,
           material: material,
           valveType: valveType,
           standard: standard,
           productType: productType,
         ),
         from: technicalCatalogProductsProvider,
         name: r'technicalCatalogProductsProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$technicalCatalogProductsHash,
         dependencies: TechnicalCatalogProductsFamily._dependencies,
         allTransitiveDependencies:
             TechnicalCatalogProductsFamily._allTransitiveDependencies,
         material: material,
         valveType: valveType,
         standard: standard,
         productType: productType,
       );

  TechnicalCatalogProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.material,
    required this.valveType,
    required this.standard,
    required this.productType,
  }) : super.internal();

  final String? material;
  final String? valveType;
  final String? standard;
  final String? productType;

  @override
  Override overrideWith(
    FutureOr<List<CatalogProduct>> Function(
      TechnicalCatalogProductsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TechnicalCatalogProductsProvider._internal(
        (ref) => create(ref as TechnicalCatalogProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        material: material,
        valveType: valveType,
        standard: standard,
        productType: productType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CatalogProduct>> createElement() {
    return _TechnicalCatalogProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TechnicalCatalogProductsProvider &&
        other.material == material &&
        other.valveType == valveType &&
        other.standard == standard &&
        other.productType == productType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, material.hashCode);
    hash = _SystemHash.combine(hash, valveType.hashCode);
    hash = _SystemHash.combine(hash, standard.hashCode);
    hash = _SystemHash.combine(hash, productType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TechnicalCatalogProductsRef
    on AutoDisposeFutureProviderRef<List<CatalogProduct>> {
  /// The parameter `material` of this provider.
  String? get material;

  /// The parameter `valveType` of this provider.
  String? get valveType;

  /// The parameter `standard` of this provider.
  String? get standard;

  /// The parameter `productType` of this provider.
  String? get productType;
}

class _TechnicalCatalogProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<CatalogProduct>>
    with TechnicalCatalogProductsRef {
  _TechnicalCatalogProductsProviderElement(super.provider);

  @override
  String? get material => (origin as TechnicalCatalogProductsProvider).material;
  @override
  String? get valveType =>
      (origin as TechnicalCatalogProductsProvider).valveType;
  @override
  String? get standard => (origin as TechnicalCatalogProductsProvider).standard;
  @override
  String? get productType =>
      (origin as TechnicalCatalogProductsProvider).productType;
}

String _$technicalCatalogDatasheetsHash() =>
    r'992e2d7b1f8049b3f43f96ce97a4fa74811a9452';

/// See also [technicalCatalogDatasheets].
@ProviderFor(technicalCatalogDatasheets)
const technicalCatalogDatasheetsProvider = TechnicalCatalogDatasheetsFamily();

/// See also [technicalCatalogDatasheets].
class TechnicalCatalogDatasheetsFamily
    extends Family<AsyncValue<List<TechnicalDatasheet>>> {
  /// See also [technicalCatalogDatasheets].
  const TechnicalCatalogDatasheetsFamily();

  /// See also [technicalCatalogDatasheets].
  TechnicalCatalogDatasheetsProvider call({
    String? material,
    String? valveType,
    String? standard,
    String? productType,
  }) {
    return TechnicalCatalogDatasheetsProvider(
      material: material,
      valveType: valveType,
      standard: standard,
      productType: productType,
    );
  }

  @override
  TechnicalCatalogDatasheetsProvider getProviderOverride(
    covariant TechnicalCatalogDatasheetsProvider provider,
  ) {
    return call(
      material: provider.material,
      valveType: provider.valveType,
      standard: provider.standard,
      productType: provider.productType,
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
  String? get name => r'technicalCatalogDatasheetsProvider';
}

/// See also [technicalCatalogDatasheets].
class TechnicalCatalogDatasheetsProvider
    extends AutoDisposeFutureProvider<List<TechnicalDatasheet>> {
  /// See also [technicalCatalogDatasheets].
  TechnicalCatalogDatasheetsProvider({
    String? material,
    String? valveType,
    String? standard,
    String? productType,
  }) : this._internal(
         (ref) => technicalCatalogDatasheets(
           ref as TechnicalCatalogDatasheetsRef,
           material: material,
           valveType: valveType,
           standard: standard,
           productType: productType,
         ),
         from: technicalCatalogDatasheetsProvider,
         name: r'technicalCatalogDatasheetsProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$technicalCatalogDatasheetsHash,
         dependencies: TechnicalCatalogDatasheetsFamily._dependencies,
         allTransitiveDependencies:
             TechnicalCatalogDatasheetsFamily._allTransitiveDependencies,
         material: material,
         valveType: valveType,
         standard: standard,
         productType: productType,
       );

  TechnicalCatalogDatasheetsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.material,
    required this.valveType,
    required this.standard,
    required this.productType,
  }) : super.internal();

  final String? material;
  final String? valveType;
  final String? standard;
  final String? productType;

  @override
  Override overrideWith(
    FutureOr<List<TechnicalDatasheet>> Function(
      TechnicalCatalogDatasheetsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TechnicalCatalogDatasheetsProvider._internal(
        (ref) => create(ref as TechnicalCatalogDatasheetsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        material: material,
        valveType: valveType,
        standard: standard,
        productType: productType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TechnicalDatasheet>> createElement() {
    return _TechnicalCatalogDatasheetsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TechnicalCatalogDatasheetsProvider &&
        other.material == material &&
        other.valveType == valveType &&
        other.standard == standard &&
        other.productType == productType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, material.hashCode);
    hash = _SystemHash.combine(hash, valveType.hashCode);
    hash = _SystemHash.combine(hash, standard.hashCode);
    hash = _SystemHash.combine(hash, productType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TechnicalCatalogDatasheetsRef
    on AutoDisposeFutureProviderRef<List<TechnicalDatasheet>> {
  /// The parameter `material` of this provider.
  String? get material;

  /// The parameter `valveType` of this provider.
  String? get valveType;

  /// The parameter `standard` of this provider.
  String? get standard;

  /// The parameter `productType` of this provider.
  String? get productType;
}

class _TechnicalCatalogDatasheetsProviderElement
    extends AutoDisposeFutureProviderElement<List<TechnicalDatasheet>>
    with TechnicalCatalogDatasheetsRef {
  _TechnicalCatalogDatasheetsProviderElement(super.provider);

  @override
  String? get material =>
      (origin as TechnicalCatalogDatasheetsProvider).material;
  @override
  String? get valveType =>
      (origin as TechnicalCatalogDatasheetsProvider).valveType;
  @override
  String? get standard =>
      (origin as TechnicalCatalogDatasheetsProvider).standard;
  @override
  String? get productType =>
      (origin as TechnicalCatalogDatasheetsProvider).productType;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
