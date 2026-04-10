import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_adapter.dart';
import '../../../../core/network/http_method.dart';
import '../dtos/get_catalog_datasheets_request_dto.dart';
import '../dtos/get_catalog_datasheets_response_dto.dart';
import '../dtos/get_catalog_products_request_dto.dart';
import '../dtos/get_catalog_products_response_dto.dart';

class TechnicalCatalogDatasource {
  const TechnicalCatalogDatasource(this._httpAdapter);

  final HttpAdapter _httpAdapter;

  Future<GetCatalogProductsResponseDto> getProducts(
    GetCatalogProductsRequestDto request,
  ) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.catalogProducts,
      method: HttpMethod.get,
      queryParameters: request.toQueryParameters(),
    );

    return GetCatalogProductsResponseDto.fromJson(response);
  }

  Future<GetCatalogDatasheetsResponseDto> getDatasheets(
    GetCatalogDatasheetsRequestDto request,
  ) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.catalogDatasheets,
      method: HttpMethod.get,
      queryParameters: request.toQueryParameters(),
    );

    return GetCatalogDatasheetsResponseDto.fromJson(response);
  }
}
