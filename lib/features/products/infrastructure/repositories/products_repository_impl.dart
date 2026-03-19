import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_datasource.dart';
import '../dtos/get_products_request_dto.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  const ProductsRepositoryImpl(this._datasource);

  final ProductsDatasource _datasource;

  @override
  Future<List<Product>> getProducts({
    String? query,
    ProductCategory? category,
  }) async {
    final response = await _datasource.getProducts(
      GetProductsRequestDto(query: query, category: category?.code),
    );

    return response.items
        .map((item) => item.toEntity())
        .toList(growable: false);
  }
}
