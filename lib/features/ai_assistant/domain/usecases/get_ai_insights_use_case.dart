import '../entities/ai_insight.dart';
import '../repositories/ai_assistant_repository.dart';

class GetAiInsightsUseCase {
  const GetAiInsightsUseCase(this._repository);

  final AiAssistantRepository _repository;

  Future<List<AiInsight>> call() {
    return _repository.getInsights();
  }
}
