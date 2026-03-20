import 'opportunity.dart';

class CreateOpportunityInput {
  const CreateOpportunityInput({
    required this.customerName,
    required this.title,
    required this.stage,
    required this.amount,
    required this.probability,
    required this.expectedCloseDate,
  });

  final String customerName;
  final String title;
  final OpportunityStage stage;
  final double amount;
  final double probability;
  final String expectedCloseDate;
}
