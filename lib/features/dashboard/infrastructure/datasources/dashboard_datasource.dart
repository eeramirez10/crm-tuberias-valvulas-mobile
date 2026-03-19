import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_adapter.dart';
import '../../../../core/network/http_method.dart';
import '../dtos/get_dashboard_summary_response_dto.dart';

class DashboardDatasource {
  const DashboardDatasource(this._httpAdapter);

  final HttpAdapter _httpAdapter;

  Future<GetDashboardSummaryResponseDto> getSummary() async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.dashboardSummary,
      method: HttpMethod.get,
    );

    return GetDashboardSummaryResponseDto.fromJson(response);
  }
}
