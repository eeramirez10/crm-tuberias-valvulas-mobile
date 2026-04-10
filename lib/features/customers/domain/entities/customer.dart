class Customer {
  const Customer({
    required this.id,
    required this.name,
    required this.segment,
    this.industrialSector = '',
    required this.contactName,
    required this.contactPhone,
    required this.city,
    this.projectState = '',
    this.projectCity = '',
    this.projectLatitude,
    this.projectLongitude,
    required this.creditStatus,
  });

  final String id;
  final String name;
  final String segment;
  final String industrialSector;
  final String contactName;
  final String contactPhone;
  final String city;
  final String projectState;
  final String projectCity;
  final double? projectLatitude;
  final double? projectLongitude;
  final String creditStatus;
}
