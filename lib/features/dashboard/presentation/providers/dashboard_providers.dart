import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_summary_use_case.dart';
import '../../infrastructure/datasources/dashboard_datasource.dart';
import '../../infrastructure/repositories/dashboard_repository_impl.dart';

part 'dashboard_providers.g.dart';

@riverpod
DashboardDatasource dashboardDatasource(Ref ref) {
  return DashboardDatasource(ref.watch(httpAdapterProvider));
}

@riverpod
DashboardRepository dashboardRepository(Ref ref) {
  return DashboardRepositoryImpl(ref.watch(dashboardDatasourceProvider));
}

@riverpod
GetDashboardSummaryUseCase getDashboardSummaryUseCase(Ref ref) {
  return GetDashboardSummaryUseCase(ref.watch(dashboardRepositoryProvider));
}

@riverpod
Future<DashboardSummary> dashboardSummary(Ref ref) {
  return ref.watch(getDashboardSummaryUseCaseProvider).call();
}
