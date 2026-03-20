class UpdateLeadInput {
  const UpdateLeadInput({
    required this.leadId,
    required this.companyName,
    required this.contactName,
    required this.contactPhone,
    required this.contactEmail,
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
  final String source;
  final String status;
  final double estimatedAmount;
  final String nextActionDate;
  final String owner;
  final String notes;
}
