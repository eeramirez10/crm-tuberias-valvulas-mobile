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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'customer_name': customerName,
      'title': title,
      'stage': stage,
      'amount': amount,
      'probability': probability,
      'expected_close_date': expectedCloseDate,
      'industrial_sector': industrialSector,
      'project_state': projectState,
      'project_city': projectCity,
      'required_delivery_time': requiredDeliveryTime,
      'main_competitor': mainCompetitor,
      'material': material,
      'schedule': schedule,
      'nominal_diameter': nominalDiameter,
      'end_type': endType,
      'valve_type': valveType,
      'pressure_class': pressureClass,
      'standard': standard,
      'loss_reason': lossReason,
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
      industrialSector: input.industrialSector,
      projectState: input.projectState,
      projectCity: input.projectCity,
      requiredDeliveryTime: input.requiredDeliveryTime,
      mainCompetitor: input.mainCompetitor,
      material: input.material,
      schedule: input.schedule,
      nominalDiameter: input.nominalDiameter,
      endType: input.endType,
      valveType: input.valveType,
      pressureClass: input.pressureClass,
      standard: input.standard,
      lossReason: input.lossReason,
    );
  }
}
