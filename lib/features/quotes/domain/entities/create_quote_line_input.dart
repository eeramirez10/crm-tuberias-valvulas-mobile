class CreateQuoteLineInput {
  const CreateQuoteLineInput({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.discountRate = 0,
  });

  final String productId;
  final int quantity;
  final double unitPrice;
  final double discountRate;
}
