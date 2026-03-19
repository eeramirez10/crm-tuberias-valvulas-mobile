class Customer {
  const Customer({
    required this.id,
    required this.name,
    required this.segment,
    required this.contactName,
    required this.contactPhone,
    required this.city,
    required this.creditStatus,
  });

  final String id;
  final String name;
  final String segment;
  final String contactName;
  final String contactPhone;
  final String city;
  final String creditStatus;
}
