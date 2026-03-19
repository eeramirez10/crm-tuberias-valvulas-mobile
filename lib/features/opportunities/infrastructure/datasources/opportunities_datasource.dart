import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_adapter.dart';
import '../../../../core/network/http_method.dart';
import '../dtos/get_opportunities_request_dto.dart';
import '../dtos/get_opportunities_response_dto.dart';
import '../dtos/update_opportunity_stage_request_dto.dart';
import '../dtos/update_opportunity_stage_response_dto.dart';

class OpportunitiesDatasource {
  const OpportunitiesDatasource(this._httpAdapter);

  final HttpAdapter _httpAdapter;

  Future<GetOpportunitiesResponseDto> getOpportunities(
    GetOpportunitiesRequestDto request,
  ) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.opportunities,
      method: HttpMethod.get,
      queryParameters: request.toQueryParameters(),
    );

    return GetOpportunitiesResponseDto.fromJson(response);
  }

  Future<UpdateOpportunityStageResponseDto> updateStage(
    UpdateOpportunityStageRequestDto request,
  ) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.updateOpportunityStage(request.opportunityId),
      method: HttpMethod.patch,
      data: request.toJson(),
    );

    return UpdateOpportunityStageResponseDto.fromJson(response);
  }
}
