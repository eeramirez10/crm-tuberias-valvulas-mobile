// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasks_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tasksDatasourceHash() => r'd44d456d4241e9932bda0c044844960fa9bd638a';

/// See also [tasksDatasource].
@ProviderFor(tasksDatasource)
final tasksDatasourceProvider = AutoDisposeProvider<TasksDatasource>.internal(
  tasksDatasource,
  name: r'tasksDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tasksDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TasksDatasourceRef = AutoDisposeProviderRef<TasksDatasource>;
String _$tasksRepositoryHash() => r'5f193b43c116dc146274a9f524ff33700d0a8d4c';

/// See also [tasksRepository].
@ProviderFor(tasksRepository)
final tasksRepositoryProvider = AutoDisposeProvider<TasksRepository>.internal(
  tasksRepository,
  name: r'tasksRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tasksRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TasksRepositoryRef = AutoDisposeProviderRef<TasksRepository>;
String _$getTasksUseCaseHash() => r'362a00c429d15783c92015d05c8df421acc7d695';

/// See also [getTasksUseCase].
@ProviderFor(getTasksUseCase)
final getTasksUseCaseProvider = AutoDisposeProvider<GetTasksUseCase>.internal(
  getTasksUseCase,
  name: r'getTasksUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getTasksUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTasksUseCaseRef = AutoDisposeProviderRef<GetTasksUseCase>;
String _$completeTaskUseCaseHash() =>
    r'977a459c5fa13bd89c6b579ec581cac8d651fd27';

/// See also [completeTaskUseCase].
@ProviderFor(completeTaskUseCase)
final completeTaskUseCaseProvider =
    AutoDisposeProvider<CompleteTaskUseCase>.internal(
      completeTaskUseCase,
      name: r'completeTaskUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$completeTaskUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompleteTaskUseCaseRef = AutoDisposeProviderRef<CompleteTaskUseCase>;
String _$tasksControllerHash() => r'bb1deb65457c73fcbf0fa0bc84f5a7d11309f19e';

/// See also [TasksController].
@ProviderFor(TasksController)
final tasksControllerProvider =
    AutoDisposeAsyncNotifierProvider<TasksController, List<TaskItem>>.internal(
      TasksController.new,
      name: r'tasksControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$tasksControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TasksController = AutoDisposeAsyncNotifier<List<TaskItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
