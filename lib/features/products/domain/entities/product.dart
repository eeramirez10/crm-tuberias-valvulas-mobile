enum ProductCategory { pipe, valve, fitting, accessory }

extension ProductCategoryX on ProductCategory {
  String get code {
    switch (this) {
      case ProductCategory.pipe:
        return 'Tuberia';
      case ProductCategory.valve:
        return 'Valvula';
      case ProductCategory.fitting:
        return 'Conexion';
      case ProductCategory.accessory:
        return 'Accesorio';
    }
  }

  String get label => code;

  static ProductCategory fromCode(String value) {
    for (final category in ProductCategory.values) {
      if (category.code.toLowerCase() == value.toLowerCase()) {
        return category;
      }
    }
    return ProductCategory.accessory;
  }
}

class Product {
  const Product({
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
  final ProductCategory category;
  final String unit;
  final int stock;
  final double listPrice;
  final double minPrice;
  final double unitCost;
}
