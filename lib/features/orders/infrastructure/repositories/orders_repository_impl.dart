import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_datasource.dart';
import '../dtos/get_orders_request_dto.dart';
import '../dtos/update_order_status_request_dto.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  const OrdersRepositoryImpl(this._datasource);

  final OrdersDatasource _datasource;

  @override
  Future<List<Order>> getOrders({OrderStatus? status}) async {
    final response = await _datasource.getOrders(
      GetOrdersRequestDto(status: status?.code),
    );

    return response.items
        .map((item) => item.toEntity())
        .toList(growable: false);
  }

  @override
  Future<Order> getOrderById(String orderId) async {
    final response = await _datasource.getOrderById(orderId);
    return response.item.toEntity();
  }

  @override
  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    final response = await _datasource.updateOrderStatus(
      UpdateOrderStatusRequestDto(orderId: orderId, status: status.code),
    );

    if (!response.ok) {
      throw StateError(response.message ?? 'No se pudo actualizar el pedido.');
    }
  }
}
