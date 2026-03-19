import '../../domain/entities/order_line.dart';

class OrderLineItemDto {
  const OrderLineItemDto({
    required this.productId,
    required this.productSku,
    required this.productName,
    required this.productCategory,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.stockAvailable,
  });

  final String productId;
  final String productSku;
  final String productName;
  final String productCategory;
  final String unit;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final int stockAvailable;

  factory OrderLineItemDto.fromJson(Map<String, dynamic> json) {
    return OrderLineItemDto(
      productId: json['product_id'] as String? ?? '',
      productSku: json['product_sku'] as String? ?? '',
      productName: json['product_name'] as String? ?? '',
      productCategory: json['product_category'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0,
      lineTotal: (json['line_total'] as num?)?.toDouble() ?? 0,
      stockAvailable: (json['stock_available'] as num?)?.toInt() ?? 0,
    );
  }

  OrderLine toEntity() {
    return OrderLine(
      productId: productId,
      productSku: productSku,
      productName: productName,
      productCategory: productCategory,
      unit: unit,
      quantity: quantity,
      unitPrice: unitPrice,
      lineTotal: lineTotal,
      stockAvailable: stockAvailable,
    );
  }
}
