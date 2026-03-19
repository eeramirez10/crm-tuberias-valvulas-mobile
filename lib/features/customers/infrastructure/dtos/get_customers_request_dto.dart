class GetCustomersRequestDto {
  const GetCustomersRequestDto({this.query});

  final String? query;

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      if (query != null && query!.isNotEmpty) 'q': query,
    };
  }
}
