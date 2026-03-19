import '../../domain/entities/create_quote_input.dart';

class CreateQuoteRequestDto {
  const CreateQuoteRequestDto({
    required this.customerName,
    required this.relatedType,
    required this.relatedId,
    required this.itemsCount,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.validUntil,
  });

  final String customerName;
  final String relatedType;
  final String relatedId;
  final int itemsCount;
  final double subtotal;
  final double discount;
  final double tax;
  final String validUntil;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'customer_name': customerName,
      'related_type': relatedType,
      'related_id': relatedId,
      'items_count': itemsCount,
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'valid_until': validUntil,
    };
  }

  factory CreateQuoteRequestDto.fromInput(CreateQuoteInput input) {
    return CreateQuoteRequestDto(
      customerName: input.customerName,
      relatedType: input.relatedType,
      relatedId: input.relatedId,
      itemsCount: input.itemsCount,
      subtotal: input.subtotal,
      discount: input.discount,
      tax: input.tax,
      validUntil: input.validUntil,
    );
  }
}
