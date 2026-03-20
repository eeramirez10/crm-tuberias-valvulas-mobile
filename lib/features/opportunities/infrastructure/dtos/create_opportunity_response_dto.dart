import '../../domain/entities/opportunity.dart';
import 'get_opportunities_response_dto.dart';

class CreateOpportunityResponseDto {
  const CreateOpportunityResponseDto({
    required this.ok,
    this.message,
    required this.item,
  });

  final bool ok;
  final String? message;
  final OpportunityItemDto item;

  factory CreateOpportunityResponseDto.fromJson(Map<String, dynamic> json) {
    return CreateOpportunityResponseDto(
      ok: json['ok'] as bool? ?? false,
      message: json['message'] as String?,
      item: OpportunityItemDto.fromJson(
        json['item'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }

  Opportunity toEntity() {
    return item.toEntity();
  }
}
