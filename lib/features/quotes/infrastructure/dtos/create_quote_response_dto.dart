import 'quote_item_dto.dart';

class CreateQuoteResponseDto {
  const CreateQuoteResponseDto({
    required this.ok,
    this.message,
    required this.item,
  });

  final bool ok;
  final String? message;
  final QuoteItemDto item;

  factory CreateQuoteResponseDto.fromJson(Map<String, dynamic> json) {
    return CreateQuoteResponseDto(
      ok: json['ok'] as bool? ?? false,
      message: json['message'] as String?,
      item: QuoteItemDto.fromJson(
        json['item'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }
}
