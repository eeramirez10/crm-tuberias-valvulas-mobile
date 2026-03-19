import '../entities/opportunity.dart';

abstract class OpportunitiesRepository {
  Future<List<Opportunity>> getOpportunities({OpportunityStage? stage});
  Future<void> updateOpportunityStage({
    required String opportunityId,
    required OpportunityStage stage,
  });
}
