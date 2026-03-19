import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_adapter.dart';
import '../../../../core/network/http_method.dart';
import '../dtos/get_leads_request_dto.dart';
import '../dtos/get_leads_response_dto.dart';

class LeadsDatasource {
  const LeadsDatasource(this._httpAdapter);

  final HttpAdapter _httpAdapter;

  Future<GetLeadsResponseDto> getLeads(GetLeadsRequestDto request) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.leads,
      method: HttpMethod.get,
      queryParameters: request.toQueryParameters(),
    );

    return GetLeadsResponseDto.fromJson(response);
  }
}
