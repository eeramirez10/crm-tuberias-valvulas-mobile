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
    required this.industrialSector,
    required this.projectState,
    required this.projectCity,
    required this.requiredDeliveryTime,
    required this.mainCompetitor,
    required this.material,
    required this.schedule,
    required this.nominalDiameter,
    required this.endType,
    required this.valveType,
    required this.pressureClass,
    required this.standard,
    required this.lossReason,
  });

  final String id;
  final String customerName;
  final String title;
  final String stage;
  final double amount;
  final double probability;
  final String expectedCloseDate;
  final String industrialSector;
  final String projectState;
  final String projectCity;
  final String requiredDeliveryTime;
  final String mainCompetitor;
  final String material;
  final String schedule;
  final String nominalDiameter;
  final String endType;
  final String valveType;
  final String pressureClass;
  final String standard;
  final String lossReason;

  factory OpportunityItemDto.fromJson(Map<String, dynamic> json) {
    return OpportunityItemDto(
      id: json['id'] as String? ?? '',
      customerName: json['customer_name'] as String? ?? '',
      title: json['title'] as String? ?? '',
      stage: json['stage'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      probability: (json['probability'] as num?)?.toDouble() ?? 0,
      expectedCloseDate: json['expected_close_date'] as String? ?? '',
      industrialSector: json['industrial_sector'] as String? ?? '',
      projectState: json['project_state'] as String? ?? '',
      projectCity: json['project_city'] as String? ?? '',
      requiredDeliveryTime: json['required_delivery_time'] as String? ?? '',
      mainCompetitor: json['main_competitor'] as String? ?? '',
      material: json['material'] as String? ?? '',
      schedule: json['schedule'] as String? ?? '',
      nominalDiameter: json['nominal_diameter'] as String? ?? '',
      endType: json['end_type'] as String? ?? '',
      valveType: json['valve_type'] as String? ?? '',
      pressureClass: json['pressure_class'] as String? ?? '',
      standard: json['standard'] as String? ?? '',
      lossReason: json['loss_reason'] as String? ?? '',
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
      industrialSector: industrialSector,
      projectState: projectState,
      projectCity: projectCity,
      requiredDeliveryTime: requiredDeliveryTime,
      mainCompetitor: mainCompetitor,
      material: material,
      schedule: schedule,
      nominalDiameter: nominalDiameter,
      endType: endType,
      valveType: valveType,
      pressureClass: pressureClass,
      standard: standard,
      lossReason: lossReason,
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
