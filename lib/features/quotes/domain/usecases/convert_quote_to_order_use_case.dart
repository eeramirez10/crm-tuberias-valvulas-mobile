import '../entities/convert_quote_result.dart';
import '../repositories/quotes_repository.dart';

class ConvertQuoteToOrderUseCase {
  const ConvertQuoteToOrderUseCase(this._repository);

  final QuotesRepository _repository;

  Future<ConvertQuoteResult> call(String quoteId) {
    return _repository.convertToOrder(quoteId);
  }
}
