import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/activity_item.dart';
import '../../domain/repositories/activities_repository.dart';
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
Future<List<ActivityItem>> activities(Ref ref) {
  return ref.watch(getActivitiesUseCaseProvider).call();
}
