import '../entities/quote.dart';
import '../repositories/quotes_repository.dart';

class GetQuoteByIdUseCase {
  const GetQuoteByIdUseCase(this._repository);

  final QuotesRepository _repository;

  Future<Quote> call(String quoteId) {
    return _repository.getQuoteById(quoteId);
  }
}
