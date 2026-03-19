import '../../domain/entities/create_task_input.dart';

class CreateTaskRequestDto {
  const CreateTaskRequestDto({
    required this.title,
    required this.type,
    required this.dueDate,
    required this.relatedTo,
  });

  final String title;
  final String type;
  final String dueDate;
  final String relatedTo;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'type': type,
      'due_date': dueDate,
      'related_to': relatedTo,
    };
  }

  factory CreateTaskRequestDto.fromInput(CreateTaskInput input) {
    return CreateTaskRequestDto(
      title: input.title,
      type: input.type,
      dueDate: input.dueDate,
      relatedTo: input.relatedTo,
    );
  }
}
