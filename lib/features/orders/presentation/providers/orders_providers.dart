import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repository.dart';
import '../../domain/usecases/get_order_by_id_use_case.dart';
import '../../domain/usecases/get_orders_use_case.dart';
import '../../domain/usecases/update_order_status_use_case.dart';
import '../../infrastructure/datasources/orders_datasource.dart';
import '../../infrastructure/repositories/orders_repository_impl.dart';

part 'orders_providers.g.dart';

class OrdersViewModel {
  const OrdersViewModel({required this.items, this.processingOrderId});

  final List<Order> items;
  final String? processingOrderId;

  bool isProcessing(String orderId) => processingOrderId == orderId;

  OrdersViewModel copyWith({
    List<Order>? items,
    String? processingOrderId,
    bool clearProcessing = false,
  }) {
    return OrdersViewModel(
      items: items ?? this.items,
      processingOrderId: clearProcessing
          ? null
          : (processingOrderId ?? this.processingOrderId),
    );
  }
}

@riverpod
OrdersDatasource ordersDatasource(Ref ref) {
  return OrdersDatasource(ref.watch(httpAdapterProvider));
}

@riverpod
OrdersRepository ordersRepository(Ref ref) {
  return OrdersRepositoryImpl(ref.watch(ordersDatasourceProvider));
}

@riverpod
GetOrdersUseCase getOrdersUseCase(Ref ref) {
  return GetOrdersUseCase(ref.watch(ordersRepositoryProvider));
}

@riverpod
GetOrderByIdUseCase getOrderByIdUseCase(Ref ref) {
  return GetOrderByIdUseCase(ref.watch(ordersRepositoryProvider));
}

@riverpod
UpdateOrderStatusUseCase updateOrderStatusUseCase(Ref ref) {
  return UpdateOrderStatusUseCase(ref.watch(ordersRepositoryProvider));
}

@riverpod
Future<Order> orderDetails(Ref ref, String orderId) {
  return ref.watch(getOrderByIdUseCaseProvider).call(orderId);
}

@riverpod
class OrdersController extends _$OrdersController {
  @override
  Future<OrdersViewModel> build() async {
    final items = await ref.watch(getOrdersUseCaseProvider).call();
    return OrdersViewModel(items: items);
  }

  Future<void> refresh() async {
    final previous =
        state.valueOrNull ?? const OrdersViewModel(items: <Order>[]);
    state = const AsyncLoading();
    try {
      final items = await ref.read(getOrdersUseCaseProvider).call();
      state = AsyncData(previous.copyWith(items: items, clearProcessing: true));
    } catch (error, stackTrace) {
      state = AsyncData(previous);
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> updateStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    final previous = state.valueOrNull;
    if (previous == null) {
      return;
    }

    state = AsyncData(previous.copyWith(processingOrderId: orderId));

    try {
      await ref
          .read(updateOrderStatusUseCaseProvider)
          .call(orderId: orderId, status: status);
      final refreshed = await ref.read(getOrdersUseCaseProvider).call();
      state = AsyncData(
        previous.copyWith(items: refreshed, clearProcessing: true),
      );
      ref.invalidate(orderDetailsProvider(orderId));
    } catch (error, stackTrace) {
      final latest = state.valueOrNull ?? previous;
      state = AsyncData(latest.copyWith(clearProcessing: true));
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
