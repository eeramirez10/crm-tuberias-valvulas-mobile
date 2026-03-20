import '../entities/create_opportunity_input.dart';
import '../entities/opportunity.dart';
import '../repositories/opportunities_repository.dart';

class CreateOpportunityUseCase {
  const CreateOpportunityUseCase(this._repository);

  final OpportunitiesRepository _repository;

  Future<Opportunity> call(CreateOpportunityInput input) {
    return _repository.createOpportunity(input);
  }
}
