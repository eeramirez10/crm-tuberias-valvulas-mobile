import '../entities/catalog_product.dart';
import '../entities/technical_datasheet.dart';

abstract class TechnicalCatalogRepository {
  Future<List<CatalogProduct>> getProducts({
    String? material,
    String? valveType,
    String? standard,
    CatalogProductType? productType,
  });

  Future<List<TechnicalDatasheet>> getDatasheets({
    String? material,
    String? valveType,
    String? standard,
    CatalogProductType? productType,
  });
}
