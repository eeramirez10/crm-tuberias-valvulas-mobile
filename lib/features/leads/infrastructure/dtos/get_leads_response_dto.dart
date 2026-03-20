import '../../domain/entities/lead.dart';

class LeadItemDto {
  const LeadItemDto({
    required this.id,
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

  factory LeadItemDto.fromJson(Map<String, dynamic> json) {
    return LeadItemDto(
      id: json['id'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      contactName: json['contact_name'] as String? ?? '',
      contactPhone: json['contact_phone'] as String? ?? '',
      contactEmail: json['contact_email'] as String? ?? '',
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
