import '../entities/opportunity.dart';
import '../repositories/opportunities_repository.dart';

class GetOpportunitiesUseCase {
  const GetOpportunitiesUseCase(this._repository);

  final OpportunitiesRepository _repository;

  Future<List<Opportunity>> call({OpportunityStage? stage}) {
    return _repository.getOpportunities(stage: stage);
  }
}
