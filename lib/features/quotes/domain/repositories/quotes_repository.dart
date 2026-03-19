import '../entities/convert_quote_result.dart';
import '../entities/create_quote_input.dart';
import '../entities/quote.dart';

abstract class QuotesRepository {
  Future<List<Quote>> getQuotes({QuoteStatus? status});

  Future<Quote> getQuoteById(String quoteId);

  Future<Quote> createQuote(CreateQuoteInput input);

  Future<void> updateQuoteStatus({
    required String quoteId,
    required QuoteStatus status,
  });

  Future<ConvertQuoteResult> convertToOrder(String quoteId);
}
