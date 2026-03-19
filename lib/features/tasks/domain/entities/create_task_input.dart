class CreateTaskInput {
  const CreateTaskInput({
    required this.title,
    required this.type,
    required this.dueDate,
    required this.relatedTo,
  });

  final String title;
  final String type;
  final String dueDate;
  final String relatedTo;
}
