import 'create_quote_line_input.dart';

class CreateQuoteInput {
  const CreateQuoteInput({
    required this.customerName,
    required this.relatedType,
    required this.relatedId,
    required this.validUntil,
    required this.lines,
    this.taxRate = 0.16,
  });

  final String customerName;
  final String relatedType;
  final String relatedId;
  final String validUntil;
  final List<CreateQuoteLineInput> lines;
  final double taxRate;
}
