class CreateActivityInput {
  const CreateActivityInput({
    required this.type,
    required this.summary,
    required this.owner,
  });

  final String type;
  final String summary;
  final String owner;
}
