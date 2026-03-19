class CreateTaskResponseDto {
  const CreateTaskResponseDto({required this.ok, this.message});

  final bool ok;
  final String? message;

  factory CreateTaskResponseDto.fromJson(Map<String, dynamic> json) {
    return CreateTaskResponseDto(
      ok: json['ok'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}
