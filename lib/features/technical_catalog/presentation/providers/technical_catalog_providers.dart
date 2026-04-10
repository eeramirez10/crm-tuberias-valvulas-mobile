import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/catalog_product.dart';
import '../../domain/entities/technical_datasheet.dart';
import '../../domain/repositories/technical_catalog_repository.dart';
import '../../domain/usecases/get_catalog_datasheets_use_case.dart';
import '../../domain/usecases/get_catalog_products_use_case.dart';
import '../../infrastructure/datasources/technical_catalog_datasource.dart';
import '../../infrastructure/repositories/technical_catalog_repository_impl.dart';

part 'technical_catalog_providers.g.dart';

@riverpod
TechnicalCatalogDatasource technicalCatalogDatasource(Ref ref) {
  return TechnicalCatalogDatasource(ref.watch(httpAdapterProvider));
}

@riverpod
TechnicalCatalogRepository technicalCatalogRepository(Ref ref) {
  return TechnicalCatalogRepositoryImpl(
    ref.watch(technicalCatalogDatasourceProvider),
  );
}

@riverpod
GetCatalogProductsUseCase getCatalogProductsUseCase(Ref ref) {
  return GetCatalogProductsUseCase(
    ref.watch(technicalCatalogRepositoryProvider),
  );
}

@riverpod
GetCatalogDatasheetsUseCase getCatalogDatasheetsUseCase(Ref ref) {
  return GetCatalogDatasheetsUseCase(
    ref.watch(technicalCatalogRepositoryProvider),
  );
}

@riverpod
Future<List<CatalogProduct>> technicalCatalogProducts(
  Ref ref, {
  String? material,
  String? valveType,
  String? standard,
  String? productType,
}) {
  return ref
      .watch(getCatalogProductsUseCaseProvider)
      .call(
        material: material,
        valveType: valveType,
        standard: standard,
        productType: productType == null
            ? null
            : CatalogProductTypeX.fromCode(productType),
      );
}

@riverpod
Future<List<TechnicalDatasheet>> technicalCatalogDatasheets(
  Ref ref, {
  String? material,
  String? valveType,
  String? standard,
  String? productType,
}) {
  return ref
      .watch(getCatalogDatasheetsUseCaseProvider)
      .call(
        material: material,
        valveType: valveType,
        standard: standard,
        productType: productType == null
            ? null
            : CatalogProductTypeX.fromCode(productType),
      );
}
