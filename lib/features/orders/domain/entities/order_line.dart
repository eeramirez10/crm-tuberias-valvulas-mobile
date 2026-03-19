class OrderLine {
  const OrderLine({
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
}
