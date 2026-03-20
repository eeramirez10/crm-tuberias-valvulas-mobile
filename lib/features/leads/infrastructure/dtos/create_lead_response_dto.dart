import '../../domain/entities/lead.dart';
import 'get_leads_response_dto.dart';

class CreateLeadResponseDto {
  const CreateLeadResponseDto({
    required this.ok,
    this.message,
    required this.item,
  });

  final bool ok;
  final String? message;
  final LeadItemDto item;

  factory CreateLeadResponseDto.fromJson(Map<String, dynamic> json) {
    return CreateLeadResponseDto(
      ok: json['ok'] as bool? ?? false,
      message: json['message'] as String?,
      item: LeadItemDto.fromJson(
        json['item'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
    );
  }

  Lead toEntity() {
    return item.toEntity();
  }
}
