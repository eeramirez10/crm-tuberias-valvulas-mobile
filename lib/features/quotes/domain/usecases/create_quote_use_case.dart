import '../entities/create_quote_input.dart';
import '../entities/quote.dart';
import '../repositories/quotes_repository.dart';

class CreateQuoteUseCase {
  const CreateQuoteUseCase(this._repository);

  final QuotesRepository _repository;

  Future<Quote> call(CreateQuoteInput input) {
    return _repository.createQuote(input);
  }
}
