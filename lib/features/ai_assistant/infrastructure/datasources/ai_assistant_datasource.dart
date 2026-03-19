import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_adapter.dart';
import '../../../../core/network/http_method.dart';
import '../dtos/generate_follow_up_draft_request_dto.dart';
import '../dtos/generate_follow_up_draft_response_dto.dart';
import '../dtos/get_ai_insights_response_dto.dart';
import '../dtos/get_ai_next_actions_response_dto.dart';
import '../dtos/get_ai_risk_summary_response_dto.dart';

class AiAssistantDatasource {
  const AiAssistantDatasource(this._httpAdapter);

  final HttpAdapter _httpAdapter;

  Future<GetAiInsightsResponseDto> getInsights() async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.aiInsights,
      method: HttpMethod.get,
    );

    return GetAiInsightsResponseDto.fromJson(response);
  }

  Future<GetAiNextActionsResponseDto> getNextActions() async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.aiNextActions,
      method: HttpMethod.get,
    );

    return GetAiNextActionsResponseDto.fromJson(response);
  }

  Future<GetAiRiskSummaryResponseDto> getRiskSummary() async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.aiRiskSummary,
      method: HttpMethod.get,
    );

    return GetAiRiskSummaryResponseDto.fromJson(response);
  }

  Future<GenerateFollowUpDraftResponseDto> generateFollowUpDraft(
    GenerateFollowUpDraftRequestDto request,
  ) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.aiFollowUpDraft,
      method: HttpMethod.post,
      data: request.toJson(),
    );

    return GenerateFollowUpDraftResponseDto.fromJson(response);
  }
}
