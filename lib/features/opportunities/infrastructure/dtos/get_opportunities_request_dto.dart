class GetOpportunitiesRequestDto {
  const GetOpportunitiesRequestDto({this.stage});

  final String? stage;

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      if (stage != null && stage!.isNotEmpty) 'stage': stage,
    };
  }
}
