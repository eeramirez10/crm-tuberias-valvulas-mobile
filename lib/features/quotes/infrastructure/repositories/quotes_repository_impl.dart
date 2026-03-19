import '../../domain/entities/convert_quote_result.dart';
import '../../domain/entities/create_quote_input.dart';
import '../../domain/entities/quote.dart';
import '../../domain/repositories/quotes_repository.dart';
import '../datasources/quotes_datasource.dart';
import '../dtos/convert_quote_to_order_request_dto.dart';
import '../dtos/create_quote_request_dto.dart';
import '../dtos/get_quotes_request_dto.dart';
import '../dtos/update_quote_status_request_dto.dart';

class QuotesRepositoryImpl implements QuotesRepository {
  const QuotesRepositoryImpl(this._datasource);

  final QuotesDatasource _datasource;

  @override
  Future<List<Quote>> getQuotes({QuoteStatus? status}) async {
    final response = await _datasource.getQuotes(
      GetQuotesRequestDto(status: status?.code),
    );

    return response.items
        .map((item) => item.toEntity())
        .toList(growable: false);
  }

  @override
  Future<Quote> getQuoteById(String quoteId) async {
    final response = await _datasource.getQuoteById(quoteId);
    return response.item.toEntity();
  }

  @override
  Future<Quote> createQuote(CreateQuoteInput input) async {
    final response = await _datasource.createQuote(
      CreateQuoteRequestDto.fromInput(input),
    );

    if (!response.ok) {
      throw StateError(response.message ?? 'No se pudo crear la cotizacion.');
    }

    return response.item.toEntity();
  }

  @override
  Future<void> updateQuoteStatus({
    required String quoteId,
    required QuoteStatus status,
  }) async {
    final response = await _datasource.updateStatus(
      UpdateQuoteStatusRequestDto(quoteId: quoteId, status: status.code),
    );

    if (!response.ok) {
      throw StateError(
        response.message ?? 'No se pudo actualizar la cotizacion.',
      );
    }
  }

  @override
  Future<ConvertQuoteResult> convertToOrder(String quoteId) async {
    final response = await _datasource.convertToOrder(
      ConvertQuoteToOrderRequestDto(quoteId: quoteId),
    );

    if (!response.ok) {
      throw StateError(response.message ?? 'No se pudo convertir a pedido.');
    }

    return response.toEntity();
  }
}
