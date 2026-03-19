import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_adapter.dart';
import '../../../../core/network/http_method.dart';
import '../dtos/get_products_request_dto.dart';
import '../dtos/get_products_response_dto.dart';

class ProductsDatasource {
  const ProductsDatasource(this._httpAdapter);

  final HttpAdapter _httpAdapter;

  Future<GetProductsResponseDto> getProducts(
    GetProductsRequestDto request,
  ) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.products,
      method: HttpMethod.get,
      queryParameters: request.toQueryParameters(),
    );

    return GetProductsResponseDto.fromJson(response);
  }
}
