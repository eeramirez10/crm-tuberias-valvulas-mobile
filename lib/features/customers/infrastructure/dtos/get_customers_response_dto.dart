import '../../domain/entities/customer.dart';

class CustomerItemDto {
  const CustomerItemDto({
    required this.id,
    required this.name,
    required this.segment,
    required this.industrialSector,
    required this.contactName,
    required this.contactPhone,
    required this.city,
    required this.projectState,
    required this.projectCity,
    required this.projectLatitude,
    required this.projectLongitude,
    required this.creditStatus,
  });

  final String id;
  final String name;
  final String segment;
  final String industrialSector;
  final String contactName;
  final String contactPhone;
  final String city;
  final String projectState;
  final String projectCity;
  final double? projectLatitude;
  final double? projectLongitude;
  final String creditStatus;

  factory CustomerItemDto.fromJson(Map<String, dynamic> json) {
    return CustomerItemDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      segment: json['segment'] as String? ?? '',
      industrialSector:
          json['industrial_sector'] as String? ??
          json['segment'] as String? ??
          '',
      contactName: json['contact_name'] as String? ?? '',
      contactPhone: json['contact_phone'] as String? ?? '',
      city: json['city'] as String? ?? '',
      projectState: json['project_state'] as String? ?? '',
      projectCity: json['project_city'] as String? ?? '',
      projectLatitude: (json['project_latitude'] as num?)?.toDouble(),
      projectLongitude: (json['project_longitude'] as num?)?.toDouble(),
      creditStatus: json['credit_status'] as String? ?? '',
    );
  }

  Customer toEntity() {
    return Customer(
      id: id,
      name: name,
      segment: segment,
      industrialSector: industrialSector,
      contactName: contactName,
      contactPhone: contactPhone,
      city: city,
      projectState: projectState,
      projectCity: projectCity,
      projectLatitude: projectLatitude,
      projectLongitude: projectLongitude,
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
