import 'order_item_dto.dart';

class GetOrderByIdResponseDto {
  const GetOrderByIdResponseDto({required this.item});

  final OrderItemDto item;

  factory GetOrderByIdResponseDto.fromJson(Map<String, dynamic> json) {
    final raw = json['item'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return GetOrderByIdResponseDto(item: OrderItemDto.fromJson(raw));
  }
}
