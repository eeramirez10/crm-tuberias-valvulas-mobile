import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_adapter.dart';
import '../../../../core/network/http_method.dart';
import '../dtos/convert_quote_to_order_request_dto.dart';
import '../dtos/convert_quote_to_order_response_dto.dart';
import '../dtos/create_quote_request_dto.dart';
import '../dtos/create_quote_response_dto.dart';
import '../dtos/get_quote_by_id_response_dto.dart';
import '../dtos/get_quotes_request_dto.dart';
import '../dtos/get_quotes_response_dto.dart';
import '../dtos/update_quote_status_request_dto.dart';
import '../dtos/update_quote_status_response_dto.dart';

class QuotesDatasource {
  const QuotesDatasource(this._httpAdapter);

  final HttpAdapter _httpAdapter;

  Future<GetQuotesResponseDto> getQuotes(GetQuotesRequestDto request) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.quotes,
      method: HttpMethod.get,
      queryParameters: request.toQueryParameters(),
    );

    return GetQuotesResponseDto.fromJson(response);
  }

  Future<GetQuoteByIdResponseDto> getQuoteById(String quoteId) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.quoteById(quoteId),
      method: HttpMethod.get,
    );

    return GetQuoteByIdResponseDto.fromJson(response);
  }

  Future<CreateQuoteResponseDto> createQuote(
    CreateQuoteRequestDto request,
  ) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.quotes,
      method: HttpMethod.post,
      data: request.toJson(),
    );

    return CreateQuoteResponseDto.fromJson(response);
  }

  Future<UpdateQuoteStatusResponseDto> updateStatus(
    UpdateQuoteStatusRequestDto request,
  ) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.updateQuoteStatus(request.quoteId),
      method: HttpMethod.patch,
      data: request.toJson(),
    );

    return UpdateQuoteStatusResponseDto.fromJson(response);
  }

  Future<ConvertQuoteToOrderResponseDto> convertToOrder(
    ConvertQuoteToOrderRequestDto request,
  ) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.convertQuoteToOrder(request.quoteId),
      method: HttpMethod.post,
    );

    return ConvertQuoteToOrderResponseDto.fromJson(response);
  }
}
