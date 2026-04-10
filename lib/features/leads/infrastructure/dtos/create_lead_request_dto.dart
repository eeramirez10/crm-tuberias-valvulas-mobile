import '../../domain/entities/create_lead_input.dart';

class CreateLeadRequestDto {
  const CreateLeadRequestDto({
    required this.companyName,
    required this.contactName,
    required this.contactPhone,
    required this.contactEmail,
    required this.industrialSector,
    required this.creditStatus,
    required this.projectState,
    required this.projectCity,
    required this.projectLatitude,
    required this.projectLongitude,
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
    required this.source,
    required this.status,
    required this.estimatedAmount,
    required this.nextActionDate,
    required this.owner,
    required this.notes,
  });

  final String companyName;
  final String contactName;
  final String contactPhone;
  final String contactEmail;
  final String industrialSector;
  final String creditStatus;
  final String projectState;
  final String projectCity;
  final double? projectLatitude;
  final double? projectLongitude;
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
  final String source;
  final String status;
  final double estimatedAmount;
  final String nextActionDate;
  final String owner;
  final String notes;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'company_name': companyName,
      'contact_name': contactName,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'industrial_sector': industrialSector,
      'credit_status': creditStatus,
      'project_state': projectState,
      'project_city': projectCity,
      'project_latitude': projectLatitude,
      'project_longitude': projectLongitude,
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
      'source': source,
      'status': status,
      'estimated_amount': estimatedAmount,
      'next_action_date': nextActionDate,
      'owner': owner,
      'notes': notes,
    };
  }

  factory CreateLeadRequestDto.fromInput(CreateLeadInput input) {
    return CreateLeadRequestDto(
      companyName: input.companyName,
      contactName: input.contactName,
      contactPhone: input.contactPhone,
      contactEmail: input.contactEmail,
      industrialSector: input.industrialSector,
      creditStatus: input.creditStatus,
      projectState: input.projectState,
      projectCity: input.projectCity,
      projectLatitude: input.projectLatitude,
      projectLongitude: input.projectLongitude,
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
      source: input.source,
      status: input.status,
      estimatedAmount: input.estimatedAmount,
      nextActionDate: input.nextActionDate,
      owner: input.owner,
      notes: input.notes,
    );
  }
}
