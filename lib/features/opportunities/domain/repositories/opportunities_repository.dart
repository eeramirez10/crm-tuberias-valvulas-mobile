import '../entities/opportunity.dart';
import '../entities/create_opportunity_input.dart';
import '../entities/update_opportunity_stage_result.dart';

abstract class OpportunitiesRepository {
  Future<List<Opportunity>> getOpportunities({OpportunityStage? stage});
  Future<Opportunity> createOpportunity(CreateOpportunityInput input);
  Future<UpdateOpportunityStageResult> updateOpportunityStage({
    required String opportunityId,
    required OpportunityStage stage,
  });
}
