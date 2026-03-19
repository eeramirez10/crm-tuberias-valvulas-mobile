import '../../domain/entities/follow_up_draft.dart';

class GenerateFollowUpDraftResponseDto {
  const GenerateFollowUpDraftResponseDto({
    required this.draft,
    required this.suggestedSubject,
  });

  final String draft;
  final String suggestedSubject;

  factory GenerateFollowUpDraftResponseDto.fromJson(Map<String, dynamic> json) {
    return GenerateFollowUpDraftResponseDto(
      draft: json['draft'] as String? ?? '',
      suggestedSubject: json['suggested_subject'] as String? ?? '',
    );
  }

  FollowUpDraft toEntity() {
    return FollowUpDraft(draft: draft, suggestedSubject: suggestedSubject);
  }
}
