import '../../domain/entities/convert_quote_result.dart';

class ConvertQuoteToOrderResponseDto {
  const ConvertQuoteToOrderResponseDto({
    required this.ok,
    required this.orderId,
    this.message,
  });

  final bool ok;
  final String orderId;
  final String? message;

  factory ConvertQuoteToOrderResponseDto.fromJson(Map<String, dynamic> json) {
    return ConvertQuoteToOrderResponseDto(
      ok: json['ok'] as bool? ?? false,
      orderId: json['order_id'] as String? ?? '',
      message: json['message'] as String?,
    );
  }

  ConvertQuoteResult toEntity() {
    return ConvertQuoteResult(ok: ok, orderId: orderId);
  }
}
