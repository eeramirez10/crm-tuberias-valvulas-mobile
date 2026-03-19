import '../entities/order.dart';

abstract class OrdersRepository {
  Future<List<Order>> getOrders({OrderStatus? status});

  Future<Order> getOrderById(String orderId);

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  });
}
