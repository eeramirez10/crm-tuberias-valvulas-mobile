import '../entities/opportunity.dart';
import '../entities/create_opportunity_input.dart';

abstract class OpportunitiesRepository {
  Future<List<Opportunity>> getOpportunities({OpportunityStage? stage});
  Future<Opportunity> createOpportunity(CreateOpportunityInput input);
  Future<void> updateOpportunityStage({
    required String opportunityId,
    required OpportunityStage stage,
  });
}
