import '../entities/ai_insight.dart';
import '../entities/ai_next_action.dart';
import '../entities/ai_risk_summary.dart';
import '../entities/follow_up_draft.dart';

abstract class AiAssistantRepository {
  Future<List<AiInsight>> getInsights();
  Future<List<AiNextAction>> getNextActions();
  Future<AiRiskSummary> getRiskSummary();

  Future<FollowUpDraft> generateFollowUpDraft({
    required String customerName,
    required String context,
    required String channel,
  });
}
