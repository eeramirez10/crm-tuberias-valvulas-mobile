import '../entities/opportunity.dart';
import '../repositories/opportunities_repository.dart';

class UpdateOpportunityStageUseCase {
  const UpdateOpportunityStageUseCase(this._repository);

  final OpportunitiesRepository _repository;

  Future<void> call({
    required String opportunityId,
    required OpportunityStage stage,
  }) {
    return _repository.updateOpportunityStage(
      opportunityId: opportunityId,
      stage: stage,
    );
  }
}
