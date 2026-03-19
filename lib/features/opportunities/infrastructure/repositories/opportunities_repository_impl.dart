import '../../domain/entities/opportunity.dart';
import '../../domain/repositories/opportunities_repository.dart';
import '../datasources/opportunities_datasource.dart';
import '../dtos/get_opportunities_request_dto.dart';
import '../dtos/update_opportunity_stage_request_dto.dart';

class OpportunitiesRepositoryImpl implements OpportunitiesRepository {
  const OpportunitiesRepositoryImpl(this._datasource);

  final OpportunitiesDatasource _datasource;

  @override
  Future<List<Opportunity>> getOpportunities({OpportunityStage? stage}) async {
    final response = await _datasource.getOpportunities(
      GetOpportunitiesRequestDto(stage: stage?.code),
    );

    return response.items
        .map((item) => item.toEntity())
        .toList(growable: false);
  }

  @override
  Future<void> updateOpportunityStage({
    required String opportunityId,
    required OpportunityStage stage,
  }) async {
    final response = await _datasource.updateStage(
      UpdateOpportunityStageRequestDto(
        opportunityId: opportunityId,
        stage: stage.code,
      ),
    );

    if (!response.ok) {
      throw StateError(response.message ?? 'No se pudo actualizar la etapa.');
    }
  }
}
