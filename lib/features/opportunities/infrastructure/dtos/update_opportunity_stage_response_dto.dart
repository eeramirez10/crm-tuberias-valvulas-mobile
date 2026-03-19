class UpdateOpportunityStageResponseDto {
  const UpdateOpportunityStageResponseDto({required this.ok, this.message});

  final bool ok;
  final String? message;

  factory UpdateOpportunityStageResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return UpdateOpportunityStageResponseDto(
      ok: json['ok'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}
