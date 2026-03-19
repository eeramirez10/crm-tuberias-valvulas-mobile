import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/task_item.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../../domain/usecases/complete_task_use_case.dart';
import '../../domain/usecases/get_tasks_use_case.dart';
import '../../infrastructure/datasources/tasks_datasource.dart';
import '../../infrastructure/repositories/tasks_repository_impl.dart';

part 'tasks_providers.g.dart';

@riverpod
TasksDatasource tasksDatasource(Ref ref) {
  return TasksDatasource(ref.watch(httpAdapterProvider));
}

@riverpod
TasksRepository tasksRepository(Ref ref) {
  return TasksRepositoryImpl(ref.watch(tasksDatasourceProvider));
}

@riverpod
GetTasksUseCase getTasksUseCase(Ref ref) {
  return GetTasksUseCase(ref.watch(tasksRepositoryProvider));
}

@riverpod
CompleteTaskUseCase completeTaskUseCase(Ref ref) {
  return CompleteTaskUseCase(ref.watch(tasksRepositoryProvider));
}

@riverpod
class TasksController extends _$TasksController {
  @override
  Future<List<TaskItem>> build() {
    return ref.watch(getTasksUseCaseProvider).call(completed: false);
  }

  Future<void> complete(String taskId) async {
    final currentItems = state.valueOrNull ?? <TaskItem>[];
    state = const AsyncLoading();

    try {
      await ref.read(completeTaskUseCaseProvider).call(taskId);
      final refreshed = await ref
          .read(getTasksUseCaseProvider)
          .call(completed: false);
      state = AsyncData(refreshed);
    } catch (_) {
      state = AsyncData(currentItems);
      rethrow;
    }
  }
}
