import '../entities/ai_risk_summary.dart';
import '../repositories/ai_assistant_repository.dart';

class GetAiRiskSummaryUseCase {
  const GetAiRiskSummaryUseCase(this._repository);

  final AiAssistantRepository _repository;

  Future<AiRiskSummary> call() {
    return _repository.getRiskSummary();
  }
}
