import '../../domain/entities/update_opportunity_stage_result.dart';

class UpdateOpportunityStageResponseDto {
  const UpdateOpportunityStageResponseDto({
    required this.ok,
    this.message,
    required this.customerCreated,
    required this.customerName,
  });

  final bool ok;
  final String? message;
  final bool customerCreated;
  final String customerName;

  factory UpdateOpportunityStageResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return UpdateOpportunityStageResponseDto(
      ok: json['ok'] as bool? ?? false,
      message: json['message'] as String?,
      customerCreated: json['customer_created'] as bool? ?? false,
      customerName: json['customer_name'] as String? ?? '',
    );
  }

  UpdateOpportunityStageResult toEntity() {
    return UpdateOpportunityStageResult(
      customerCreated: customerCreated,
      customerName: customerName,
    );
  }
}
