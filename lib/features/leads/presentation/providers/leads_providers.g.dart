// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leads_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$leadsDatasourceHash() => r'fa6c375dbce18ca7c7d56ac9a33a1a58e565b129';

/// See also [leadsDatasource].
@ProviderFor(leadsDatasource)
final leadsDatasourceProvider = AutoDisposeProvider<LeadsDatasource>.internal(
  leadsDatasource,
  name: r'leadsDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$leadsDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LeadsDatasourceRef = AutoDisposeProviderRef<LeadsDatasource>;
String _$leadsRepositoryHash() => r'2814bc368db6771e65183d335c2ace9dd736cd82';

/// See also [leadsRepository].
@ProviderFor(leadsRepository)
final leadsRepositoryProvider = AutoDisposeProvider<LeadsRepository>.internal(
  leadsRepository,
  name: r'leadsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$leadsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LeadsRepositoryRef = AutoDisposeProviderRef<LeadsRepository>;
String _$getLeadsUseCaseHash() => r'15d9aa440c514a2298e5a0bf19b351834306985c';

/// See also [getLeadsUseCase].
@ProviderFor(getLeadsUseCase)
final getLeadsUseCaseProvider = AutoDisposeProvider<GetLeadsUseCase>.internal(
  getLeadsUseCase,
  name: r'getLeadsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getLeadsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetLeadsUseCaseRef = AutoDisposeProviderRef<GetLeadsUseCase>;
String _$createLeadUseCaseHash() => r'687e13b961b13caef043d1de8a3ee12f3295e46b';

/// See also [createLeadUseCase].
@ProviderFor(createLeadUseCase)
final createLeadUseCaseProvider =
    AutoDisposeProvider<CreateLeadUseCase>.internal(
      createLeadUseCase,
      name: r'createLeadUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createLeadUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateLeadUseCaseRef = AutoDisposeProviderRef<CreateLeadUseCase>;
String _$leadsHash() => r'e23fa120706da89e033ab6f281b998ccd8ce39b1';

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

/// See also [leads].
@ProviderFor(leads)
const leadsProvider = LeadsFamily();

/// See also [leads].
class LeadsFamily extends Family<AsyncValue<List<Lead>>> {
  /// See also [leads].
  const LeadsFamily();

  /// See also [leads].
  LeadsProvider call({String? status}) {
    return LeadsProvider(status: status);
  }

  @override
  LeadsProvider getProviderOverride(covariant LeadsProvider provider) {
    return call(status: provider.status);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'leadsProvider';
}

/// See also [leads].
class LeadsProvider extends AutoDisposeFutureProvider<List<Lead>> {
  /// See also [leads].
  LeadsProvider({String? status})
    : this._internal(
        (ref) => leads(ref as LeadsRef, status: status),
        from: leadsProvider,
        name: r'leadsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$leadsHash,
        dependencies: LeadsFamily._dependencies,
        allTransitiveDependencies: LeadsFamily._allTransitiveDependencies,
        status: status,
      );

  LeadsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String? status;

  @override
  Override overrideWith(
    FutureOr<List<Lead>> Function(LeadsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LeadsProvider._internal(
        (ref) => create(ref as LeadsRef),
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
  AutoDisposeFutureProviderElement<List<Lead>> createElement() {
    return _LeadsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LeadsProvider && other.status == status;
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
mixin LeadsRef on AutoDisposeFutureProviderRef<List<Lead>> {
  /// The parameter `status` of this provider.
  String? get status;
}

class _LeadsProviderElement extends AutoDisposeFutureProviderElement<List<Lead>>
    with LeadsRef {
  _LeadsProviderElement(super.provider);

  @override
  String? get status => (origin as LeadsProvider).status;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
