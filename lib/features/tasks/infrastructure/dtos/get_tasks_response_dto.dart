import '../../domain/entities/task_item.dart';

class TaskItemDto {
  const TaskItemDto({
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

  factory TaskItemDto.fromJson(Map<String, dynamic> json) {
    return TaskItemDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
      dueDate: json['due_date'] as String? ?? '',
      relatedTo: json['related_to'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }

  TaskItem toEntity() {
    return TaskItem(
      id: id,
      title: title,
      type: type,
      dueDate: dueDate,
      relatedTo: relatedTo,
      completed: completed,
    );
  }
}

class GetTasksResponseDto {
  const GetTasksResponseDto({required this.items});

  final List<TaskItemDto> items;

  factory GetTasksResponseDto.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return GetTasksResponseDto(
      items: rawItems.map(TaskItemDto.fromJson).toList(growable: false),
    );
  }
}
