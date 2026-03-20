import '../../domain/entities/update_lead_input.dart';

class UpdateLeadRequestDto {
  const UpdateLeadRequestDto({
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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'company_name': companyName,
      'contact_name': contactName,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'source': source,
      'status': status,
      'estimated_amount': estimatedAmount,
      'next_action_date': nextActionDate,
      'owner': owner,
      'notes': notes,
    };
  }

  factory UpdateLeadRequestDto.fromInput(UpdateLeadInput input) {
    return UpdateLeadRequestDto(
      leadId: input.leadId,
      companyName: input.companyName,
      contactName: input.contactName,
      contactPhone: input.contactPhone,
      contactEmail: input.contactEmail,
      source: input.source,
      status: input.status,
      estimatedAmount: input.estimatedAmount,
      nextActionDate: input.nextActionDate,
      owner: input.owner,
      notes: input.notes,
    );
  }
}
