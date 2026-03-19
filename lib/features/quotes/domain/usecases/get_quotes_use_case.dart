import '../entities/quote.dart';
import '../repositories/quotes_repository.dart';

class GetQuotesUseCase {
  const GetQuotesUseCase(this._repository);

  final QuotesRepository _repository;

  Future<List<Quote>> call({QuoteStatus? status}) {
    return _repository.getQuotes(status: status);
  }
}
