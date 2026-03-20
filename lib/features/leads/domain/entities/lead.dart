class Lead {
  const Lead({
    required this.id,
    required this.companyName,
    this.contactName = '',
    this.contactPhone = '',
    this.contactEmail = '',
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
      source: source ?? this.source,
      status: status ?? this.status,
      estimatedAmount: estimatedAmount ?? this.estimatedAmount,
      nextActionDate: nextActionDate ?? this.nextActionDate,
      owner: owner ?? this.owner,
      notes: notes ?? this.notes,
    );
  }
}
