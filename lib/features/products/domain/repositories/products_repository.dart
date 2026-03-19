import '../entities/product.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProducts({String? query, ProductCategory? category});
}
