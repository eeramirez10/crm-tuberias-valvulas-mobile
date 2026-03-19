import 'order_line.dart';

enum OrderStatus { newOrder, picking, shipped, delivered, cancelled }

extension OrderStatusX on OrderStatus {
  String get code {
    switch (this) {
      case OrderStatus.newOrder:
        return 'Nuevo';
      case OrderStatus.picking:
        return 'En surtido';
      case OrderStatus.shipped:
        return 'Enviado';
      case OrderStatus.delivered:
        return 'Entregado';
      case OrderStatus.cancelled:
        return 'Cancelado';
    }
  }

  String get label => code;

  static OrderStatus fromCode(String value) {
    for (final status in OrderStatus.values) {
      if (status.code.toLowerCase() == value.toLowerCase()) {
        return status;
      }
    }

    return OrderStatus.newOrder;
  }
}

class Order {
  const Order({
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
  final OrderStatus status;
  final double total;
  final String createdAt;
  final String promisedDate;
  final String? shippedAt;
  final String? deliveredAt;
  final bool inventoryReserved;
  final List<OrderLine> lines;
}
