class CreateQuoteInput {
  const CreateQuoteInput({
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
}
