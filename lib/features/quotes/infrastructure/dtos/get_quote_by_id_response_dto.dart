import 'quote_item_dto.dart';

class GetQuoteByIdResponseDto {
  const GetQuoteByIdResponseDto({required this.item});

  final QuoteItemDto item;

  factory GetQuoteByIdResponseDto.fromJson(Map<String, dynamic> json) {
    final raw = (json['item'] as Map<String, dynamic>? ?? <String, dynamic>{});
    return GetQuoteByIdResponseDto(item: QuoteItemDto.fromJson(raw));
  }
}
