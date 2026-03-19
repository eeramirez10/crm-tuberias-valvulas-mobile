class TaskItem {
  const TaskItem({
    required this.id,
    required this.title,
    required this.type,
    required this.dueDate,
    required this.relatedTo,
    required this.completed,
  });

  final String id;
  final String title;
  final String type;
  final String dueDate;
  final String relatedTo;
  final bool completed;
}
