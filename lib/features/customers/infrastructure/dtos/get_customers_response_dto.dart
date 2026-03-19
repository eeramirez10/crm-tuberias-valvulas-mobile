import '../../domain/entities/customer.dart';

class CustomerItemDto {
  const CustomerItemDto({
    required this.id,
    required this.name,
    required this.segment,
    required this.contactName,
    required this.contactPhone,
    required this.city,
    required this.creditStatus,
  });

  final String id;
  final String name;
  final String segment;
  final String contactName;
  final String contactPhone;
  final String city;
  final String creditStatus;

  factory CustomerItemDto.fromJson(Map<String, dynamic> json) {
    return CustomerItemDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      segment: json['segment'] as String? ?? '',
      contactName: json['contact_name'] as String? ?? '',
      contactPhone: json['contact_phone'] as String? ?? '',
      city: json['city'] as String? ?? '',
      creditStatus: json['credit_status'] as String? ?? '',
    );
  }

  Customer toEntity() {
    return Customer(
      id: id,
      name: name,
      segment: segment,
      contactName: contactName,
      contactPhone: contactPhone,
      city: city,
      creditStatus: creditStatus,
    );
  }
}

class GetCustomersResponseDto {
  const GetCustomersResponseDto({required this.items});

  final List<CustomerItemDto> items;

  factory GetCustomersResponseDto.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return GetCustomersResponseDto(
      items: rawItems.map(CustomerItemDto.fromJson).toList(growable: false),
    );
  }
}
