import '../../domain/entities/lead.dart';

class LeadItemDto {
  const LeadItemDto({
    required this.id,
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

  final String id;
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

  factory LeadItemDto.fromJson(Map<String, dynamic> json) {
    return LeadItemDto(
      id: json['id'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      contactName: json['contact_name'] as String? ?? '',
      contactPhone: json['contact_phone'] as String? ?? '',
      contactEmail: json['contact_email'] as String? ?? '',
      industrialSector: json['industrial_sector'] as String? ?? '',
      creditStatus: json['credit_status'] as String? ?? '',
      projectState: json['project_state'] as String? ?? '',
      projectCity: json['project_city'] as String? ?? '',
      projectLatitude: (json['project_latitude'] as num?)?.toDouble(),
      projectLongitude: (json['project_longitude'] as num?)?.toDouble(),
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
      source: json['source'] as String? ?? '',
      status: json['status'] as String? ?? '',
      estimatedAmount: (json['estimated_amount'] as num?)?.toDouble() ?? 0,
      nextActionDate: json['next_action_date'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
    );
  }

  Lead toEntity() {
    return Lead(
      id: id,
      companyName: companyName,
      contactName: contactName,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      industrialSector: industrialSector,
      creditStatus: creditStatus,
      projectState: projectState,
      projectCity: projectCity,
      projectLatitude: projectLatitude,
      projectLongitude: projectLongitude,
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
      source: source,
      status: status,
      estimatedAmount: estimatedAmount,
      nextActionDate: nextActionDate,
      owner: owner,
      notes: notes,
    );
  }
}

class GetLeadsResponseDto {
  const GetLeadsResponseDto({required this.items});

  final List<LeadItemDto> items;

  factory GetLeadsResponseDto.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return GetLeadsResponseDto(
      items: rawItems.map(LeadItemDto.fromJson).toList(growable: false),
    );
  }
}
