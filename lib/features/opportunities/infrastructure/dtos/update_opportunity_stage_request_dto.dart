class UpdateOpportunityStageRequestDto {
  const UpdateOpportunityStageRequestDto({
    required this.opportunityId,
    required this.stage,
  });

  final String opportunityId;
  final String stage;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'stage': stage};
  }
}
