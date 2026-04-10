import '../../domain/entities/catalog_product.dart';

class CatalogProductItemDto {
  const CatalogProductItemDto({
    required this.id,
    required this.sku,
    required this.name,
    required this.productType,
    required this.material,
    required this.schedule,
    required this.nominalDiameter,
    required this.endType,
    required this.valveType,
    required this.pressureClass,
    required this.standard,
    required this.manufacturer,
    required this.datasheetIds,
  });

  final String id;
  final String sku;
  final String name;
  final String productType;
  final String material;
  final String schedule;
  final String nominalDiameter;
  final String endType;
  final String valveType;
  final String pressureClass;
  final String standard;
  final String manufacturer;
  final List<String> datasheetIds;

  factory CatalogProductItemDto.fromJson(Map<String, dynamic> json) {
    return CatalogProductItemDto(
      id: json['id'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      name: json['name'] as String? ?? '',
      productType: json['product_type'] as String? ?? '',
      material: json['material'] as String? ?? '',
      schedule: json['schedule'] as String? ?? '',
      nominalDiameter: json['nominal_diameter'] as String? ?? '',
      endType: json['end_type'] as String? ?? '',
      valveType: json['valve_type'] as String? ?? '',
      pressureClass: json['pressure_class'] as String? ?? '',
      standard: json['standard'] as String? ?? '',
      manufacturer: json['manufacturer'] as String? ?? '',
      datasheetIds: (json['datasheet_ids'] as List<dynamic>? ?? <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
    );
  }

  CatalogProduct toEntity() {
    return CatalogProduct(
      id: id,
      sku: sku,
      name: name,
      type: CatalogProductTypeX.fromCode(productType),
      material: material,
      schedule: schedule,
      nominalDiameter: nominalDiameter,
      endType: endType,
      valveType: valveType,
      pressureClass: pressureClass,
      standard: standard,
      manufacturer: manufacturer,
      datasheetIds: datasheetIds,
    );
  }
}

class GetCatalogProductsResponseDto {
  const GetCatalogProductsResponseDto({required this.items});

  final List<CatalogProductItemDto> items;

  factory GetCatalogProductsResponseDto.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return GetCatalogProductsResponseDto(
      items: rawItems
          .map(CatalogProductItemDto.fromJson)
          .toList(growable: false),
    );
  }
}
