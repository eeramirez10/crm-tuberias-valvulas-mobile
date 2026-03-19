import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../../infrastructure/datasources/products_datasource.dart';
import '../../infrastructure/repositories/products_repository_impl.dart';

part 'products_providers.g.dart';

@riverpod
ProductsDatasource productsDatasource(Ref ref) {
  return ProductsDatasource(ref.watch(httpAdapterProvider));
}

@riverpod
ProductsRepository productsRepository(Ref ref) {
  return ProductsRepositoryImpl(ref.watch(productsDatasourceProvider));
}

@riverpod
GetProductsUseCase getProductsUseCase(Ref ref) {
  return GetProductsUseCase(ref.watch(productsRepositoryProvider));
}

@riverpod
Future<List<Product>> products(Ref ref, {String? query, String? category}) {
  return ref
      .watch(getProductsUseCaseProvider)
      .call(
        query: query,
        category: category == null ? null : ProductCategoryX.fromCode(category),
      );
}
