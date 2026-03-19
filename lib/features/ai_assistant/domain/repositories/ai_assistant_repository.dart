import '../entities/ai_insight.dart';
import '../entities/follow_up_draft.dart';

abstract class AiAssistantRepository {
  Future<List<AiInsight>> getInsights();

  Future<FollowUpDraft> generateFollowUpDraft({
    required String customerName,
    required String context,
    required String channel,
  });
}
