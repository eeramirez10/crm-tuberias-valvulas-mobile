// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotes_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quotesDatasourceHash() => r'28d134788012da6912d8dbcbf48e84bd9c1f1ddb';

/// See also [quotesDatasource].
@ProviderFor(quotesDatasource)
final quotesDatasourceProvider = AutoDisposeProvider<QuotesDatasource>.internal(
  quotesDatasource,
  name: r'quotesDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quotesDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuotesDatasourceRef = AutoDisposeProviderRef<QuotesDatasource>;
String _$quotesRepositoryHash() => r'282dca11c933f14bea26cb1516892c5259718c77';

/// See also [quotesRepository].
@ProviderFor(quotesRepository)
final quotesRepositoryProvider = AutoDisposeProvider<QuotesRepository>.internal(
  quotesRepository,
  name: r'quotesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quotesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuotesRepositoryRef = AutoDisposeProviderRef<QuotesRepository>;
String _$getQuotesUseCaseHash() => r'15d056ce2d3db2265d6a00b2178c9a9824d42b2c';

/// See also [getQuotesUseCase].
@ProviderFor(getQuotesUseCase)
final getQuotesUseCaseProvider = AutoDisposeProvider<GetQuotesUseCase>.internal(
  getQuotesUseCase,
  name: r'getQuotesUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getQuotesUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetQuotesUseCaseRef = AutoDisposeProviderRef<GetQuotesUseCase>;
String _$getQuoteByIdUseCaseHash() =>
    r'3ae0e62cf7fd3a448415c6f0717efba00d046740';

/// See also [getQuoteByIdUseCase].
@ProviderFor(getQuoteByIdUseCase)
final getQuoteByIdUseCaseProvider =
    AutoDisposeProvider<GetQuoteByIdUseCase>.internal(
      getQuoteByIdUseCase,
      name: r'getQuoteByIdUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$getQuoteByIdUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetQuoteByIdUseCaseRef = AutoDisposeProviderRef<GetQuoteByIdUseCase>;
String _$createQuoteUseCaseHash() =>
    r'12dfd7dc564463925cec4c53a9996a317e927568';

/// See also [createQuoteUseCase].
@ProviderFor(createQuoteUseCase)
final createQuoteUseCaseProvider =
    AutoDisposeProvider<CreateQuoteUseCase>.internal(
      createQuoteUseCase,
      name: r'createQuoteUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createQuoteUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateQuoteUseCaseRef = AutoDisposeProviderRef<CreateQuoteUseCase>;
String _$updateQuoteStatusUseCaseHash() =>
    r'2621e065d3f98cf64cc63776bc3cab7f00afe929';

/// See also [updateQuoteStatusUseCase].
@ProviderFor(updateQuoteStatusUseCase)
final updateQuoteStatusUseCaseProvider =
    AutoDisposeProvider<UpdateQuoteStatusUseCase>.internal(
      updateQuoteStatusUseCase,
      name: r'updateQuoteStatusUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$updateQuoteStatusUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateQuoteStatusUseCaseRef =
    AutoDisposeProviderRef<UpdateQuoteStatusUseCase>;
String _$convertQuoteToOrderUseCaseHash() =>
    r'ac7f7abbbb06d9011c2d9700bb8cff73b9b7a251';

/// See also [convertQuoteToOrderUseCase].
@ProviderFor(convertQuoteToOrderUseCase)
final convertQuoteToOrderUseCaseProvider =
    AutoDisposeProvider<ConvertQuoteToOrderUseCase>.internal(
      convertQuoteToOrderUseCase,
      name: r'convertQuoteToOrderUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$convertQuoteToOrderUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConvertQuoteToOrderUseCaseRef =
    AutoDisposeProviderRef<ConvertQuoteToOrderUseCase>;
String _$quoteDetailsHash() => r'e172be9dc1f66bc89bf34c5cd43704f3745b9826';

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

/// See also [quoteDetails].
@ProviderFor(quoteDetails)
const quoteDetailsProvider = QuoteDetailsFamily();

/// See also [quoteDetails].
class QuoteDetailsFamily extends Family<AsyncValue<Quote>> {
  /// See also [quoteDetails].
  const QuoteDetailsFamily();

  /// See also [quoteDetails].
  QuoteDetailsProvider call(String quoteId) {
    return QuoteDetailsProvider(quoteId);
  }

  @override
  QuoteDetailsProvider getProviderOverride(
    covariant QuoteDetailsProvider provider,
  ) {
    return call(provider.quoteId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'quoteDetailsProvider';
}

/// See also [quoteDetails].
class QuoteDetailsProvider extends AutoDisposeFutureProvider<Quote> {
  /// See also [quoteDetails].
  QuoteDetailsProvider(String quoteId)
    : this._internal(
        (ref) => quoteDetails(ref as QuoteDetailsRef, quoteId),
        from: quoteDetailsProvider,
        name: r'quoteDetailsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$quoteDetailsHash,
        dependencies: QuoteDetailsFamily._dependencies,
        allTransitiveDependencies:
            QuoteDetailsFamily._allTransitiveDependencies,
        quoteId: quoteId,
      );

  QuoteDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.quoteId,
  }) : super.internal();

  final String quoteId;

  @override
  Override overrideWith(
    FutureOr<Quote> Function(QuoteDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuoteDetailsProvider._internal(
        (ref) => create(ref as QuoteDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        quoteId: quoteId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Quote> createElement() {
    return _QuoteDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuoteDetailsProvider && other.quoteId == quoteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, quoteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuoteDetailsRef on AutoDisposeFutureProviderRef<Quote> {
  /// The parameter `quoteId` of this provider.
  String get quoteId;
}

class _QuoteDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Quote>
    with QuoteDetailsRef {
  _QuoteDetailsProviderElement(super.provider);

  @override
  String get quoteId => (origin as QuoteDetailsProvider).quoteId;
}

String _$quotesControllerHash() => r'd5fd8ace4e5ad202b278452523930af9bcb9da48';

/// See also [QuotesController].
@ProviderFor(QuotesController)
final quotesControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      QuotesController,
      QuotesViewModel
    >.internal(
      QuotesController.new,
      name: r'quotesControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$quotesControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$QuotesController = AutoDisposeAsyncNotifier<QuotesViewModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
