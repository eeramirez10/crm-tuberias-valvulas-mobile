import '../../domain/entities/lead.dart';

class LeadItemDto {
  const LeadItemDto({
    required this.id,
    required this.companyName,
    required this.source,
    required this.status,
    required this.estimatedAmount,
    required this.nextActionDate,
    required this.owner,
  });

  final String id;
  final String companyName;
  final String source;
  final String status;
  final double estimatedAmount;
  final String nextActionDate;
  final String owner;

  factory LeadItemDto.fromJson(Map<String, dynamic> json) {
    return LeadItemDto(
      id: json['id'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      source: json['source'] as String? ?? '',
      status: json['status'] as String? ?? '',
      estimatedAmount: (json['estimated_amount'] as num?)?.toDouble() ?? 0,
      nextActionDate: json['next_action_date'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
    );
  }

  Lead toEntity() {
    return Lead(
      id: id,
      companyName: companyName,
      source: source,
      status: status,
      estimatedAmount: estimatedAmount,
      nextActionDate: nextActionDate,
      owner: owner,
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
