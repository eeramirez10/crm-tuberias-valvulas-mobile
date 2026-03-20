import '../../domain/entities/create_opportunity_input.dart';
import '../../domain/entities/opportunity.dart';

class CreateOpportunityRequestDto {
  const CreateOpportunityRequestDto({
    required this.customerName,
    required this.title,
    required this.stage,
    required this.amount,
    required this.probability,
    required this.expectedCloseDate,
  });

  final String customerName;
  final String title;
  final String stage;
  final double amount;
  final double probability;
  final String expectedCloseDate;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'customer_name': customerName,
      'title': title,
      'stage': stage,
      'amount': amount,
      'probability': probability,
      'expected_close_date': expectedCloseDate,
    };
  }

  factory CreateOpportunityRequestDto.fromInput(CreateOpportunityInput input) {
    return CreateOpportunityRequestDto(
      customerName: input.customerName,
      title: input.title,
      stage: input.stage.code,
      amount: input.amount,
      probability: input.probability,
      expectedCloseDate: input.expectedCloseDate,
    );
  }
}
