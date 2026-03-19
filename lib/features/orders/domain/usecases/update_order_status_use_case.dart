import '../entities/order.dart';
import '../repositories/orders_repository.dart';

class UpdateOrderStatusUseCase {
  const UpdateOrderStatusUseCase(this._repository);

  final OrdersRepository _repository;

  Future<void> call({required String orderId, required OrderStatus status}) {
    return _repository.updateOrderStatus(orderId: orderId, status: status);
  }
}
