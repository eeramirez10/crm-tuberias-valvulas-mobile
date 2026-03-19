import '../entities/follow_up_draft.dart';
import '../repositories/ai_assistant_repository.dart';

class GenerateFollowUpDraftUseCase {
  const GenerateFollowUpDraftUseCase(this._repository);

  final AiAssistantRepository _repository;

  Future<FollowUpDraft> call({
    required String customerName,
    required String context,
    required String channel,
  }) {
    return _repository.generateFollowUpDraft(
      customerName: customerName,
      context: context,
      channel: channel,
    );
  }
}
