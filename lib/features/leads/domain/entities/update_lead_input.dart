class UpdateLeadInput {
  const UpdateLeadInput({
    required this.leadId,
    required this.companyName,
    required this.contactName,
    required this.contactPhone,
    required this.contactEmail,
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
    required this.notes,
  });

  final String leadId;
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
}
