import 'opportunity.dart';

class CreateOpportunityInput {
  const CreateOpportunityInput({
    required this.customerName,
    required this.title,
    required this.stage,
    required this.amount,
    required this.probability,
    required this.expectedCloseDate,
    this.industrialSector = '',
    this.projectState = '',
    this.projectCity = '',
    this.requiredDeliveryTime = '',
    this.mainCompetitor = '',
    this.material = '',
    this.schedule = '',
    this.nominalDiameter = '',
    this.endType = '',
    this.valveType = '',
    this.pressureClass = '',
    this.standard = '',
    this.lossReason = '',
  });

  final String customerName;
  final String title;
  final OpportunityStage stage;
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
}
