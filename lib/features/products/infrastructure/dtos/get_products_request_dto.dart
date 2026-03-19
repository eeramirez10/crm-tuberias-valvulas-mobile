class GetProductsRequestDto {
  const GetProductsRequestDto({this.query, this.category});

  final String? query;
  final String? category;

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      if (query != null && query!.trim().isNotEmpty) 'q': query,
      if (category != null && category!.trim().isNotEmpty) 'category': category,
    };
  }
}
