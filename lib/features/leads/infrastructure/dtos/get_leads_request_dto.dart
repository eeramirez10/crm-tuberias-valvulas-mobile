class GetLeadsRequestDto {
  const GetLeadsRequestDto({this.status});

  final String? status;

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      if (status != null && status!.isNotEmpty) 'status': status,
    };
  }
}
