import '../entities/catalog_product.dart';
import '../entities/technical_datasheet.dart';
import '../repositories/technical_catalog_repository.dart';

class GetCatalogDatasheetsUseCase {
  const GetCatalogDatasheetsUseCase(this._repository);

  final TechnicalCatalogRepository _repository;

  Future<List<TechnicalDatasheet>> call({
    String? material,
    String? valveType,
    String? standard,
    CatalogProductType? productType,
  }) {
    return _repository.getDatasheets(
      material: material,
      valveType: valveType,
      standard: standard,
      productType: productType,
    );
  }
}
