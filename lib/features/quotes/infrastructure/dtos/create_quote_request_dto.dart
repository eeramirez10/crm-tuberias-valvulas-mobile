import '../../domain/entities/create_quote_input.dart';

class CreateQuoteLineRequestDto {
  const CreateQuoteLineRequestDto({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.discountRate,
  });

  final String productId;
  final int quantity;
  final double unitPrice;
  final double discountRate;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'discount_rate': discountRate,
    };
  }
}

class CreateQuoteRequestDto {
  const CreateQuoteRequestDto({
    required this.customerName,
    required this.relatedType,
    required this.relatedId,
    required this.validUntil,
    required this.lines,
    required this.taxRate,
  });

  final String customerName;
  final String relatedType;
  final String relatedId;
  final String validUntil;
  final List<CreateQuoteLineRequestDto> lines;
  final double taxRate;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'customer_name': customerName,
      'related_type': relatedType,
      'related_id': relatedId,
      'valid_until': validUntil,
      'tax_rate': taxRate,
      'lines': lines.map((item) => item.toJson()).toList(growable: false),
    };
  }

  factory CreateQuoteRequestDto.fromInput(CreateQuoteInput input) {
    return CreateQuoteRequestDto(
      customerName: input.customerName,
      relatedType: input.relatedType,
      relatedId: input.relatedId,
      validUntil: input.validUntil,
      taxRate: input.taxRate,
      lines: input.lines
          .map(
            (line) => CreateQuoteLineRequestDto(
              productId: line.productId,
              quantity: line.quantity,
              unitPrice: line.unitPrice,
              discountRate: line.discountRate,
            ),
          )
          .toList(growable: false),
    );
  }
}
