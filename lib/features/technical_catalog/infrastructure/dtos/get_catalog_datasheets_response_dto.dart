import '../../domain/entities/technical_datasheet.dart';

class TechnicalDatasheetItemDto {
  const TechnicalDatasheetItemDto({
    required this.id,
    required this.title,
    required this.manufacturer,
    required this.fileType,
    required this.url,
    required this.relatedSku,
  });

  final String id;
  final String title;
  final String manufacturer;
  final String fileType;
  final String url;
  final String relatedSku;

  factory TechnicalDatasheetItemDto.fromJson(Map<String, dynamic> json) {
    return TechnicalDatasheetItemDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      manufacturer: json['manufacturer'] as String? ?? '',
      fileType: json['file_type'] as String? ?? '',
      url: json['url'] as String? ?? '',
      relatedSku: json['related_sku'] as String? ?? '',
    );
  }

  TechnicalDatasheet toEntity() {
    return TechnicalDatasheet(
      id: id,
      title: title,
      manufacturer: manufacturer,
      fileType: fileType,
      url: url,
      relatedSku: relatedSku,
    );
  }
}

class GetCatalogDatasheetsResponseDto {
  const GetCatalogDatasheetsResponseDto({required this.items});

  final List<TechnicalDatasheetItemDto> items;

  factory GetCatalogDatasheetsResponseDto.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return GetCatalogDatasheetsResponseDto(
      items: rawItems
          .map(TechnicalDatasheetItemDto.fromJson)
          .toList(growable: false),
    );
  }
}
