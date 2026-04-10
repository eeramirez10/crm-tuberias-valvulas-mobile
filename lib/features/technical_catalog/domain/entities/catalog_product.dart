enum CatalogProductType { pipe, valve, fitting, accessory }

extension CatalogProductTypeX on CatalogProductType {
  String get code {
    switch (this) {
      case CatalogProductType.pipe:
        return 'Tuberia';
      case CatalogProductType.valve:
        return 'Valvula';
      case CatalogProductType.fitting:
        return 'Conexion';
      case CatalogProductType.accessory:
        return 'Accesorio';
    }
  }

  static CatalogProductType fromCode(String value) {
    for (final type in CatalogProductType.values) {
      if (type.code.toLowerCase() == value.toLowerCase()) {
        return type;
      }
    }
    return CatalogProductType.accessory;
  }
}

class CatalogProduct {
  const CatalogProduct({
    required this.id,
    required this.sku,
    required this.name,
    required this.type,
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
  final CatalogProductType type;
  final String material;
  final String schedule;
  final String nominalDiameter;
  final String endType;
  final String valveType;
  final String pressureClass;
  final String standard;
  final String manufacturer;
  final List<String> datasheetIds;
}
