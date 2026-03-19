import '../../domain/entities/order.dart';
import 'order_line_item_dto.dart';

class OrderItemDto {
  const OrderItemDto({
    required this.id,
    required this.code,
    required this.quoteId,
    required this.quoteCode,
    required this.customerName,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.promisedDate,
    required this.shippedAt,
    required this.deliveredAt,
    required this.inventoryReserved,
    required this.lines,
  });

  final String id;
  final String code;
  final String quoteId;
  final String quoteCode;
  final String customerName;
  final String status;
  final double total;
  final String createdAt;
  final String promisedDate;
  final String? shippedAt;
  final String? deliveredAt;
  final bool inventoryReserved;
  final List<OrderLineItemDto> lines;

  factory OrderItemDto.fromJson(Map<String, dynamic> json) {
    final rawLines = (json['lines'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return OrderItemDto(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      quoteId: json['quote_id'] as String? ?? '',
      quoteCode: json['quote_code'] as String? ?? '',
      customerName: json['customer_name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      total: (json['total'] as num?)?.toDouble() ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      promisedDate: json['promised_date'] as String? ?? '',
      shippedAt: json['shipped_at'] as String?,
      deliveredAt: json['delivered_at'] as String?,
      inventoryReserved: json['inventory_reserved'] as bool? ?? false,
      lines: rawLines.map(OrderLineItemDto.fromJson).toList(growable: false),
    );
  }

  Order toEntity() {
    return Order(
      id: id,
      code: code,
      quoteId: quoteId,
      quoteCode: quoteCode,
      customerName: customerName,
      status: OrderStatusX.fromCode(status),
      total: total,
      createdAt: createdAt,
      promisedDate: promisedDate,
      shippedAt: shippedAt,
      deliveredAt: deliveredAt,
      inventoryReserved: inventoryReserved,
      lines: lines.map((item) => item.toEntity()).toList(growable: false),
    );
  }
}
