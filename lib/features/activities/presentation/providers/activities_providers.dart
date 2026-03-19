import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/activity_item.dart';
import '../../domain/entities/create_activity_input.dart';
import '../../domain/repositories/activities_repository.dart';
import '../../domain/usecases/create_activity_use_case.dart';
import '../../domain/usecases/get_activities_use_case.dart';
import '../../infrastructure/datasources/activities_datasource.dart';
import '../../infrastructure/repositories/activities_repository_impl.dart';

part 'activities_providers.g.dart';

@riverpod
ActivitiesDatasource activitiesDatasource(Ref ref) {
  return ActivitiesDatasource(ref.watch(httpAdapterProvider));
}

@riverpod
ActivitiesRepository activitiesRepository(Ref ref) {
  return ActivitiesRepositoryImpl(ref.watch(activitiesDatasourceProvider));
}

@riverpod
GetActivitiesUseCase getActivitiesUseCase(Ref ref) {
  return GetActivitiesUseCase(ref.watch(activitiesRepositoryProvider));
}

@riverpod
CreateActivityUseCase createActivityUseCase(Ref ref) {
  return CreateActivityUseCase(ref.watch(activitiesRepositoryProvider));
}

@Riverpod(keepAlive: true)
class ActivitiesTimelineController extends _$ActivitiesTimelineController {
  @override
  Future<List<ActivityItem>> build() {
    return ref.watch(getActivitiesUseCaseProvider).call();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final items = await ref.read(getActivitiesUseCaseProvider).call();
    state = AsyncData(items);
  }

  Future<void> logInteraction({
    required String type,
    required String summary,
    String owner = 'Erick Ramirez',
  }) async {
    final previous = state.valueOrNull ?? <ActivityItem>[];
    state = const AsyncLoading();

    try {
      await ref
          .read(createActivityUseCaseProvider)
          .call(
            CreateActivityInput(type: type, summary: summary, owner: owner),
          );
      final refreshed = await ref.read(getActivitiesUseCaseProvider).call();
      state = AsyncData(refreshed);
    } catch (_) {
      state = AsyncData(previous);
      rethrow;
    }
  }
}
