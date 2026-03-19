import '../../domain/entities/quote_line.dart';

class QuoteLineItemDto {
  const QuoteLineItemDto({
    required this.productId,
    required this.productSku,
    required this.productName,
    required this.productCategory,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    required this.minUnitPrice,
    required this.unitCost,
    required this.stockAvailable,
    required this.lineSubtotal,
    required this.lineDiscount,
    required this.lineTotal,
    required this.marginRate,
  });

  final String productId;
  final String productSku;
  final String productName;
  final String productCategory;
  final String unit;
  final int quantity;
  final double unitPrice;
  final double minUnitPrice;
  final double unitCost;
  final int stockAvailable;
  final double lineSubtotal;
  final double lineDiscount;
  final double lineTotal;
  final double marginRate;

  factory QuoteLineItemDto.fromJson(Map<String, dynamic> json) {
    return QuoteLineItemDto(
      productId: json['product_id'] as String? ?? '',
      productSku: json['product_sku'] as String? ?? '',
      productName: json['product_name'] as String? ?? '',
      productCategory: json['product_category'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0,
      minUnitPrice: (json['min_unit_price'] as num?)?.toDouble() ?? 0,
      unitCost: (json['unit_cost'] as num?)?.toDouble() ?? 0,
      stockAvailable: (json['stock_available'] as num?)?.toInt() ?? 0,
      lineSubtotal: (json['line_subtotal'] as num?)?.toDouble() ?? 0,
      lineDiscount: (json['line_discount'] as num?)?.toDouble() ?? 0,
      lineTotal: (json['line_total'] as num?)?.toDouble() ?? 0,
      marginRate: (json['margin_rate'] as num?)?.toDouble() ?? 0,
    );
  }

  QuoteLine toEntity() {
    return QuoteLine(
      productId: productId,
      productSku: productSku,
      productName: productName,
      productCategory: productCategory,
      unit: unit,
      quantity: quantity,
      unitPrice: unitPrice,
      minUnitPrice: minUnitPrice,
      unitCost: unitCost,
      stockAvailable: stockAvailable,
      lineSubtotal: lineSubtotal,
      lineDiscount: lineDiscount,
      lineTotal: lineTotal,
      marginRate: marginRate,
    );
  }
}
