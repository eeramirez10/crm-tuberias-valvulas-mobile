import '../entities/ai_next_action.dart';
import '../repositories/ai_assistant_repository.dart';

class GetAiNextActionsUseCase {
  const GetAiNextActionsUseCase(this._repository);

  final AiAssistantRepository _repository;

  Future<List<AiNextAction>> call() {
    return _repository.getNextActions();
  }
}
