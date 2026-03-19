import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_adapter.dart';
import '../../../../core/network/http_method.dart';
import '../dtos/get_order_by_id_response_dto.dart';
import '../dtos/get_orders_request_dto.dart';
import '../dtos/get_orders_response_dto.dart';
import '../dtos/update_order_status_request_dto.dart';
import '../dtos/update_order_status_response_dto.dart';

class OrdersDatasource {
  const OrdersDatasource(this._httpAdapter);

  final HttpAdapter _httpAdapter;

  Future<GetOrdersResponseDto> getOrders(GetOrdersRequestDto request) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.orders,
      method: HttpMethod.get,
      queryParameters: request.toQueryParameters(),
    );

    return GetOrdersResponseDto.fromJson(response);
  }

  Future<GetOrderByIdResponseDto> getOrderById(String orderId) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.orderById(orderId),
      method: HttpMethod.get,
    );

    return GetOrderByIdResponseDto.fromJson(response);
  }

  Future<UpdateOrderStatusResponseDto> updateOrderStatus(
    UpdateOrderStatusRequestDto request,
  ) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.updateOrderStatus(request.orderId),
      method: HttpMethod.patch,
      data: request.toJson(),
    );

    return UpdateOrderStatusResponseDto.fromJson(response);
  }
}
