import '../../domain/entities/product.dart';

class ProductItemDto {
  const ProductItemDto({
    required this.id,
    required this.sku,
    required this.name,
    required this.category,
    required this.unit,
    required this.stock,
    required this.listPrice,
    required this.minPrice,
    required this.unitCost,
  });

  final String id;
  final String sku;
  final String name;
  final String category;
  final String unit;
  final int stock;
  final double listPrice;
  final double minPrice;
  final double unitCost;

  factory ProductItemDto.fromJson(Map<String, dynamic> json) {
    return ProductItemDto(
      id: json['id'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      listPrice: (json['list_price'] as num?)?.toDouble() ?? 0,
      minPrice: (json['min_price'] as num?)?.toDouble() ?? 0,
      unitCost: (json['unit_cost'] as num?)?.toDouble() ?? 0,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      sku: sku,
      name: name,
      category: ProductCategoryX.fromCode(category),
      unit: unit,
      stock: stock,
      listPrice: listPrice,
      minPrice: minPrice,
      unitCost: unitCost,
    );
  }
}

class GetProductsResponseDto {
  const GetProductsResponseDto({required this.items});

  final List<ProductItemDto> items;

  factory GetProductsResponseDto.fromJson(Map<String, dynamic> json) {
    final raw = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return GetProductsResponseDto(
      items: raw.map(ProductItemDto.fromJson).toList(growable: false),
    );
  }
}
