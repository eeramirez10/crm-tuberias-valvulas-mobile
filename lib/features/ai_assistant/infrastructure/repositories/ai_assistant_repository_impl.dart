import '../../domain/entities/ai_insight.dart';
import '../../domain/entities/follow_up_draft.dart';
import '../../domain/repositories/ai_assistant_repository.dart';
import '../datasources/ai_assistant_datasource.dart';
import '../dtos/generate_follow_up_draft_request_dto.dart';

class AiAssistantRepositoryImpl implements AiAssistantRepository {
  const AiAssistantRepositoryImpl(this._datasource);

  final AiAssistantDatasource _datasource;

  @override
  Future<List<AiInsight>> getInsights() async {
    final response = await _datasource.getInsights();
    return response.items
        .map((item) => item.toEntity())
        .toList(growable: false);
  }

  @override
  Future<FollowUpDraft> generateFollowUpDraft({
    required String customerName,
    required String context,
    required String channel,
  }) async {
    final response = await _datasource.generateFollowUpDraft(
      GenerateFollowUpDraftRequestDto(
        customerName: customerName,
        context: context,
        channel: channel,
      ),
    );

    return response.toEntity();
  }
}
