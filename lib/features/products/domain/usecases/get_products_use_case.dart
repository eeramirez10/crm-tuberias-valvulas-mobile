import '../entities/product.dart';
import '../repositories/products_repository.dart';

class GetProductsUseCase {
  const GetProductsUseCase(this._repository);

  final ProductsRepository _repository;

  Future<List<Product>> call({String? query, ProductCategory? category}) {
    return _repository.getProducts(query: query, category: category);
  }
}
