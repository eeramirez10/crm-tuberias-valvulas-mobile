import '../../domain/entities/opportunity.dart';

class OpportunityItemDto {
  const OpportunityItemDto({
    required this.id,
    required this.customerName,
    required this.title,
    required this.stage,
    required this.amount,
    required this.probability,
    required this.expectedCloseDate,
  });

  final String id;
  final String customerName;
  final String title;
  final String stage;
  final double amount;
  final double probability;
  final String expectedCloseDate;

  factory OpportunityItemDto.fromJson(Map<String, dynamic> json) {
    return OpportunityItemDto(
      id: json['id'] as String? ?? '',
      customerName: json['customer_name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      stage: json['stage'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      probability: (json['probability'] as num?)?.toDouble() ?? 0,
      expectedCloseDate: json['expected_close_date'] as String? ?? '',
    );
  }

  Opportunity toEntity() {
    return Opportunity(
      id: id,
      customerName: customerName,
      title: title,
      stage: OpportunityStageX.fromCode(stage),
      amount: amount,
      probability: probability,
      expectedCloseDate: expectedCloseDate,
    );
  }
}

class GetOpportunitiesResponseDto {
  const GetOpportunitiesResponseDto({required this.items});

  final List<OpportunityItemDto> items;

  factory GetOpportunitiesResponseDto.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return GetOpportunitiesResponseDto(
      items: rawItems.map(OpportunityItemDto.fromJson).toList(growable: false),
    );
  }
}
