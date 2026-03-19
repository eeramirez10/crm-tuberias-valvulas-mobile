class QuoteLine {
  const QuoteLine({
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
}
