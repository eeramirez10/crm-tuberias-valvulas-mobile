class TechnicalDatasheet {
  const TechnicalDatasheet({
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
}
