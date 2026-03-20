import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/create_opportunity_input.dart';
import '../../domain/entities/opportunity.dart';
import '../../domain/entities/update_opportunity_stage_result.dart';
import '../../domain/repositories/opportunities_repository.dart';
import '../../domain/usecases/create_opportunity_use_case.dart';
import '../../domain/usecases/get_opportunities_use_case.dart';
import '../../domain/usecases/update_opportunity_stage_use_case.dart';
import '../../infrastructure/datasources/opportunities_datasource.dart';
import '../../infrastructure/repositories/opportunities_repository_impl.dart';

part 'opportunities_providers.g.dart';

@riverpod
OpportunitiesDatasource opportunitiesDatasource(Ref ref) {
  return OpportunitiesDatasource(ref.watch(httpAdapterProvider));
}

@riverpod
OpportunitiesRepository opportunitiesRepository(Ref ref) {
  return OpportunitiesRepositoryImpl(
    ref.watch(opportunitiesDatasourceProvider),
  );
}

@riverpod
GetOpportunitiesUseCase getOpportunitiesUseCase(Ref ref) {
  return GetOpportunitiesUseCase(ref.watch(opportunitiesRepositoryProvider));
}

@riverpod
CreateOpportunityUseCase createOpportunityUseCase(Ref ref) {
  return CreateOpportunityUseCase(ref.watch(opportunitiesRepositoryProvider));
}

@riverpod
UpdateOpportunityStageUseCase updateOpportunityStageUseCase(Ref ref) {
  return UpdateOpportunityStageUseCase(
    ref.watch(opportunitiesRepositoryProvider),
  );
}

@riverpod
class OpportunitiesController extends _$OpportunitiesController {
  @override
  Future<List<Opportunity>> build() {
    return ref.watch(getOpportunitiesUseCaseProvider).call();
  }

  Future<UpdateOpportunityStageResult> moveToStage({
    required String opportunityId,
    required OpportunityStage stage,
  }) async {
    final previous = state.valueOrNull ?? <Opportunity>[];
    state = const AsyncLoading();

    try {
      final result = await ref
          .read(updateOpportunityStageUseCaseProvider)
          .call(opportunityId: opportunityId, stage: stage);
      final refreshed = await ref.read(getOpportunitiesUseCaseProvider).call();
      state = AsyncData(refreshed);
      return result;
    } catch (_) {
      state = AsyncData(previous);
      rethrow;
    }
  }

  Future<void> createOpportunity(CreateOpportunityInput input) async {
    final previous = state.valueOrNull ?? <Opportunity>[];
    state = const AsyncLoading();

    try {
      await ref.read(createOpportunityUseCaseProvider).call(input);
      final refreshed = await ref.read(getOpportunitiesUseCaseProvider).call();
      state = AsyncData(refreshed);
    } catch (_) {
      state = AsyncData(previous);
      rethrow;
    }
  }
}
