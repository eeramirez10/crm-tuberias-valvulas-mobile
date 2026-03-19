import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/convert_quote_result.dart';
import '../../domain/entities/create_quote_input.dart';
import '../../domain/entities/quote.dart';
import '../../domain/repositories/quotes_repository.dart';
import '../../domain/usecases/convert_quote_to_order_use_case.dart';
import '../../domain/usecases/create_quote_use_case.dart';
import '../../domain/usecases/get_quote_by_id_use_case.dart';
import '../../domain/usecases/get_quotes_use_case.dart';
import '../../domain/usecases/update_quote_status_use_case.dart';
import '../../infrastructure/datasources/quotes_datasource.dart';
import '../../infrastructure/repositories/quotes_repository_impl.dart';

part 'quotes_providers.g.dart';

class QuotesViewModel {
  const QuotesViewModel({
    required this.items,
    this.isCreating = false,
    this.processingQuoteId,
  });

  final List<Quote> items;
  final bool isCreating;
  final String? processingQuoteId;

  bool isProcessing(String quoteId) => processingQuoteId == quoteId;

  QuotesViewModel copyWith({
    List<Quote>? items,
    bool? isCreating,
    String? processingQuoteId,
    bool clearProcessing = false,
  }) {
    return QuotesViewModel(
      items: items ?? this.items,
      isCreating: isCreating ?? this.isCreating,
      processingQuoteId: clearProcessing
          ? null
          : (processingQuoteId ?? this.processingQuoteId),
    );
  }
}

@riverpod
QuotesDatasource quotesDatasource(Ref ref) {
  return QuotesDatasource(ref.watch(httpAdapterProvider));
}

@riverpod
QuotesRepository quotesRepository(Ref ref) {
  return QuotesRepositoryImpl(ref.watch(quotesDatasourceProvider));
}

@riverpod
GetQuotesUseCase getQuotesUseCase(Ref ref) {
  return GetQuotesUseCase(ref.watch(quotesRepositoryProvider));
}

@riverpod
GetQuoteByIdUseCase getQuoteByIdUseCase(Ref ref) {
  return GetQuoteByIdUseCase(ref.watch(quotesRepositoryProvider));
}

@riverpod
CreateQuoteUseCase createQuoteUseCase(Ref ref) {
  return CreateQuoteUseCase(ref.watch(quotesRepositoryProvider));
}

@riverpod
UpdateQuoteStatusUseCase updateQuoteStatusUseCase(Ref ref) {
  return UpdateQuoteStatusUseCase(ref.watch(quotesRepositoryProvider));
}

@riverpod
ConvertQuoteToOrderUseCase convertQuoteToOrderUseCase(Ref ref) {
  return ConvertQuoteToOrderUseCase(ref.watch(quotesRepositoryProvider));
}

@riverpod
Future<Quote> quoteDetails(Ref ref, String quoteId) {
  return ref.watch(getQuoteByIdUseCaseProvider).call(quoteId);
}

@riverpod
class QuotesController extends _$QuotesController {
  @override
  Future<QuotesViewModel> build() async {
    final items = await ref.watch(getQuotesUseCaseProvider).call();
    return QuotesViewModel(items: items);
  }

  Future<void> refresh() async {
    final previous =
        state.valueOrNull ?? const QuotesViewModel(items: <Quote>[]);
    state = const AsyncLoading();
    try {
      final items = await ref.read(getQuotesUseCaseProvider).call();
      state = AsyncData(previous.copyWith(items: items));
    } catch (error, stackTrace) {
      state = AsyncData(previous);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<Quote> createQuote(CreateQuoteInput input) async {
    final previous = state.valueOrNull;
    if (previous == null) {
      throw StateError('Estado de cotizaciones no disponible.');
    }

    state = AsyncData(previous.copyWith(isCreating: true));

    try {
      final created = await ref.read(createQuoteUseCaseProvider).call(input);
      final refreshed = await ref.read(getQuotesUseCaseProvider).call();

      state = AsyncData(
        previous.copyWith(
          isCreating: false,
          items: refreshed,
          clearProcessing: true,
        ),
      );

      return created;
    } catch (error, stackTrace) {
      final latest = state.valueOrNull ?? previous;
      state = AsyncData(latest.copyWith(isCreating: false));
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> updateStatus({
    required String quoteId,
    required QuoteStatus status,
  }) async {
    final previous = state.valueOrNull;
    if (previous == null) {
      return;
    }

    state = AsyncData(previous.copyWith(processingQuoteId: quoteId));

    try {
      await ref
          .read(updateQuoteStatusUseCaseProvider)
          .call(quoteId: quoteId, status: status);
      final refreshed = await ref.read(getQuotesUseCaseProvider).call();

      state = AsyncData(
        previous.copyWith(items: refreshed, clearProcessing: true),
      );
      ref.invalidate(quoteDetailsProvider(quoteId));
    } catch (error, stackTrace) {
      final latest = state.valueOrNull ?? previous;
      state = AsyncData(latest.copyWith(clearProcessing: true));
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<ConvertQuoteResult> convertToOrder(String quoteId) async {
    final previous = state.valueOrNull;
    if (previous == null) {
      throw StateError('Estado de cotizaciones no disponible.');
    }

    state = AsyncData(previous.copyWith(processingQuoteId: quoteId));

    try {
      final result = await ref
          .read(convertQuoteToOrderUseCaseProvider)
          .call(quoteId);
      final refreshed = await ref.read(getQuotesUseCaseProvider).call();

      state = AsyncData(
        previous.copyWith(items: refreshed, clearProcessing: true),
      );
      ref.invalidate(quoteDetailsProvider(quoteId));
      return result;
    } catch (error, stackTrace) {
      final latest = state.valueOrNull ?? previous;
      state = AsyncData(latest.copyWith(clearProcessing: true));
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
