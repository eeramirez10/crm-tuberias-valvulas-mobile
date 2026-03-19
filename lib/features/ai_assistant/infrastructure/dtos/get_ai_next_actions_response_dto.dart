import '../../domain/entities/ai_next_action.dart';

class AiNextActionItemDto {
  const AiNextActionItemDto({
    required this.id,
    required this.title,
    required this.reason,
    required this.priority,
    required this.targetType,
    required this.targetId,
    required this.suggestedTaskTitle,
    required this.suggestedTaskType,
    required this.suggestedDueDate,
  });

  final String id;
  final String title;
  final String reason;
  final String priority;
  final String targetType;
  final String targetId;
  final String suggestedTaskTitle;
  final String suggestedTaskType;
  final String suggestedDueDate;

  factory AiNextActionItemDto.fromJson(Map<String, dynamic> json) {
    return AiNextActionItemDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      priority: json['priority'] as String? ?? '',
      targetType: json['target_type'] as String? ?? '',
      targetId: json['target_id'] as String? ?? '',
      suggestedTaskTitle: json['suggested_task_title'] as String? ?? '',
      suggestedTaskType: json['suggested_task_type'] as String? ?? '',
      suggestedDueDate: json['suggested_due_date'] as String? ?? '',
    );
  }

  AiNextAction toEntity() {
    return AiNextAction(
      id: id,
      title: title,
      reason: reason,
      priority: priority,
      targetType: targetType,
      targetId: targetId,
      suggestedTaskTitle: suggestedTaskTitle,
      suggestedTaskType: suggestedTaskType,
      suggestedDueDate: suggestedDueDate,
    );
  }
}

class GetAiNextActionsResponseDto {
  const GetAiNextActionsResponseDto({required this.items});

  final List<AiNextActionItemDto> items;

  factory GetAiNextActionsResponseDto.fromJson(Map<String, dynamic> json) {
    final raw = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return GetAiNextActionsResponseDto(
      items: raw.map(AiNextActionItemDto.fromJson).toList(growable: false),
    );
  }
}
