import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class GetOrdersUseCase {
  const GetOrdersUseCase(this._repository);

  final OrdersRepository _repository;

  Future<List<Order>> call({OrderStatus? status}) {
    return _repository.getOrders(status: status);
  }
}
