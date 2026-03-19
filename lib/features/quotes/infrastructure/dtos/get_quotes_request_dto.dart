class GetQuotesRequestDto {
  const GetQuotesRequestDto({this.status});

  final String? status;

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      if (status != null && status!.trim().isNotEmpty) 'status': status,
    };
  }
}
