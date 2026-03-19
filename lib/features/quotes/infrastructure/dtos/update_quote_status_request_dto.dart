class UpdateQuoteStatusRequestDto {
  const UpdateQuoteStatusRequestDto({
    required this.quoteId,
    required this.status,
  });

  final String quoteId;
  final String status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'status': status};
  }
}
