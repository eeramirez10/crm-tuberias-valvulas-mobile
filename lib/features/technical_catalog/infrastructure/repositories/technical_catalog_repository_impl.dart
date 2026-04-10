import '../../domain/entities/catalog_product.dart';
import '../../domain/entities/technical_datasheet.dart';
import '../../domain/repositories/technical_catalog_repository.dart';
import '../datasources/technical_catalog_datasource.dart';
import '../dtos/get_catalog_datasheets_request_dto.dart';
import '../dtos/get_catalog_products_request_dto.dart';

class TechnicalCatalogRepositoryImpl implements TechnicalCatalogRepository {
  const TechnicalCatalogRepositoryImpl(this._datasource);

  final TechnicalCatalogDatasource _datasource;

  @override
  Future<List<CatalogProduct>> getProducts({
    String? material,
    String? valveType,
    String? standard,
    CatalogProductType? productType,
  }) async {
    final response = await _datasource.getProducts(
      GetCatalogProductsRequestDto(
        material: material,
        valveType: valveType,
        standard: standard,
        productType: productType?.code,
      ),
    );

    return response.items
        .map((item) => item.toEntity())
        .toList(growable: false);
  }

  @override
  Future<List<TechnicalDatasheet>> getDatasheets({
    String? material,
    String? valveType,
    String? standard,
    CatalogProductType? productType,
  }) async {
    final response = await _datasource.getDatasheets(
      GetCatalogDatasheetsRequestDto(
        material: material,
        valveType: valveType,
        standard: standard,
        productType: productType?.code,
      ),
    );

    return response.items
        .map((item) => item.toEntity())
        .toList(growable: false);
  }
}
