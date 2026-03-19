import '../../domain/entities/ai_insight.dart';

class AiInsightItemDto {
  const AiInsightItemDto({
    required this.id,
    required this.title,
    required this.detail,
    required this.priority,
  });

  final String id;
  final String title;
  final String detail;
  final String priority;

  factory AiInsightItemDto.fromJson(Map<String, dynamic> json) {
    return AiInsightItemDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      detail: json['detail'] as String? ?? '',
      priority: json['priority'] as String? ?? '',
    );
  }

  AiInsight toEntity() {
    return AiInsight(id: id, title: title, detail: detail, priority: priority);
  }
}

class GetAiInsightsResponseDto {
  const GetAiInsightsResponseDto({required this.items});

  final List<AiInsightItemDto> items;

  factory GetAiInsightsResponseDto.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return GetAiInsightsResponseDto(
      items: rawItems.map(AiInsightItemDto.fromJson).toList(growable: false),
    );
  }
}
