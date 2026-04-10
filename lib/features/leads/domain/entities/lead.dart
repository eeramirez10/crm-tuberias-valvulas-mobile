class Lead {
  const Lead({
    required this.id,
    required this.companyName,
    this.contactName = '',
    this.contactPhone = '',
    this.contactEmail = '',
    this.industrialSector = '',
    this.creditStatus = '',
    this.projectState = '',
    this.projectCity = '',
    this.projectLatitude,
    this.projectLongitude,
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
    required this.source,
    required this.status,
    required this.estimatedAmount,
    required this.nextActionDate,
    required this.owner,
    this.notes = '',
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

  Lead copyWith({
    String? id,
    String? companyName,
    String? contactName,
    String? contactPhone,
    String? contactEmail,
    String? industrialSector,
    String? creditStatus,
    String? projectState,
    String? projectCity,
    double? projectLatitude,
    double? projectLongitude,
    String? requiredDeliveryTime,
    String? mainCompetitor,
    String? material,
    String? schedule,
    String? nominalDiameter,
    String? endType,
    String? valveType,
    String? pressureClass,
    String? standard,
    String? lossReason,
    String? source,
    String? status,
    double? estimatedAmount,
    String? nextActionDate,
    String? owner,
    String? notes,
  }) {
    return Lead(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      industrialSector: industrialSector ?? this.industrialSector,
      creditStatus: creditStatus ?? this.creditStatus,
      projectState: projectState ?? this.projectState,
      projectCity: projectCity ?? this.projectCity,
      projectLatitude: projectLatitude ?? this.projectLatitude,
      projectLongitude: projectLongitude ?? this.projectLongitude,
      requiredDeliveryTime: requiredDeliveryTime ?? this.requiredDeliveryTime,
      mainCompetitor: mainCompetitor ?? this.mainCompetitor,
      material: material ?? this.material,
      schedule: schedule ?? this.schedule,
      nominalDiameter: nominalDiameter ?? this.nominalDiameter,
      endType: endType ?? this.endType,
      valveType: valveType ?? this.valveType,
      pressureClass: pressureClass ?? this.pressureClass,
      standard: standard ?? this.standard,
      lossReason: lossReason ?? this.lossReason,
      source: source ?? this.source,
      status: status ?? this.status,
      estimatedAmount: estimatedAmount ?? this.estimatedAmount,
      nextActionDate: nextActionDate ?? this.nextActionDate,
      owner: owner ?? this.owner,
      notes: notes ?? this.notes,
    );
  }
}
