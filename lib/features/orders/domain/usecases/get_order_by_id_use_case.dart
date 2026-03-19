import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class GetOrderByIdUseCase {
  const GetOrderByIdUseCase(this._repository);

  final OrdersRepository _repository;

  Future<Order> call(String orderId) {
    return _repository.getOrderById(orderId);
  }
}
