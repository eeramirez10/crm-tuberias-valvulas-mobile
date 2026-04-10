class GetCatalogProductsRequestDto {
  const GetCatalogProductsRequestDto({
    this.material,
    this.valveType,
    this.standard,
    this.productType,
  });

  final String? material;
  final String? valveType;
  final String? standard;
  final String? productType;

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      if (material != null && material!.trim().isNotEmpty) 'material': material,
      if (valveType != null && valveType!.trim().isNotEmpty)
        'valve_type': valveType,
      if (standard != null && standard!.trim().isNotEmpty) 'standard': standard,
      if (productType != null && productType!.trim().isNotEmpty)
        'product_type': productType,
    };
  }
}
