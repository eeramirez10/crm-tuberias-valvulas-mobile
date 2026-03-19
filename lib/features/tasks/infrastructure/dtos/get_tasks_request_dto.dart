class GetTasksRequestDto {
  const GetTasksRequestDto({this.completed});

  final bool? completed;

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{if (completed != null) 'completed': completed};
  }
}
