import 'quote_item_dto.dart';

class GetQuotesResponseDto {
  const GetQuotesResponseDto({required this.items});

  final List<QuoteItemDto> items;

  factory GetQuotesResponseDto.fromJson(Map<String, dynamic> json) {
    final raw = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return GetQuotesResponseDto(
      items: raw.map(QuoteItemDto.fromJson).toList(growable: false),
    );
  }
}
