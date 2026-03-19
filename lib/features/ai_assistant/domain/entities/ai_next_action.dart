class AiNextAction {
  const AiNextAction({
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
}
