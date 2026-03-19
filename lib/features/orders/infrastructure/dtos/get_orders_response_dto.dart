import 'order_item_dto.dart';

class GetOrdersResponseDto {
  const GetOrdersResponseDto({required this.items});

  final List<OrderItemDto> items;

  factory GetOrdersResponseDto.fromJson(Map<String, dynamic> json) {
    final raw = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return GetOrdersResponseDto(
      items: raw.map(OrderItemDto.fromJson).toList(growable: false),
    );
  }
}
