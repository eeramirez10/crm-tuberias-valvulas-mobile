import '../entities/catalog_product.dart';
import '../repositories/technical_catalog_repository.dart';

class GetCatalogProductsUseCase {
  const GetCatalogProductsUseCase(this._repository);

  final TechnicalCatalogRepository _repository;

  Future<List<CatalogProduct>> call({
    String? material,
    String? valveType,
    String? standard,
    CatalogProductType? productType,
  }) {
    return _repository.getProducts(
      material: material,
      valveType: valveType,
      standard: standard,
      productType: productType,
    );
  }
}
