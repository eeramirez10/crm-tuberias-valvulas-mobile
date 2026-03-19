import '../entities/quote.dart';
import '../repositories/quotes_repository.dart';

class UpdateQuoteStatusUseCase {
  const UpdateQuoteStatusUseCase(this._repository);

  final QuotesRepository _repository;

  Future<void> call({required String quoteId, required QuoteStatus status}) {
    return _repository.updateQuoteStatus(quoteId: quoteId, status: status);
  }
}
