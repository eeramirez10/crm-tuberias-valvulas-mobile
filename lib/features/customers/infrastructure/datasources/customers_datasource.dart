import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_adapter.dart';
import '../../../../core/network/http_method.dart';
import '../dtos/get_customers_request_dto.dart';
import '../dtos/get_customers_response_dto.dart';

class CustomersDatasource {
  const CustomersDatasource(this._httpAdapter);

  final HttpAdapter _httpAdapter;

  Future<GetCustomersResponseDto> getCustomers(
    GetCustomersRequestDto request,
  ) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.customers,
      method: HttpMethod.get,
      queryParameters: request.toQueryParameters(),
    );

    return GetCustomersResponseDto.fromJson(response);
  }
}
