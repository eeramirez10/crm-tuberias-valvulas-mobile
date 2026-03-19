import '../../domain/entities/activity_item.dart';

class ActivityItemDto {
  const ActivityItemDto({
    required this.id,
    required this.type,
    required this.summary,
    required this.owner,
    required this.createdAt,
  });

  final String id;
  final String type;
  final String summary;
  final String owner;
  final String createdAt;

  factory ActivityItemDto.fromJson(Map<String, dynamic> json) {
    return ActivityItemDto(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  ActivityItem toEntity() {
    return ActivityItem(
      id: id,
      type: type,
      summary: summary,
      owner: owner,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime(2000),
    );
  }
}

class GetActivitiesResponseDto {
  final List<ActivityItemDto> items;

  const GetActivitiesResponseDto({required this.items});

  factory GetActivitiesResponseDto.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return GetActivitiesResponseDto(
      items: rawItems.map(ActivityItemDto.fromJson).toList(growable: false),
    );
  }
}
