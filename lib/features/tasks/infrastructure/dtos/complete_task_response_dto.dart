class CompleteTaskResponseDto {
  const CompleteTaskResponseDto({required this.ok, this.message});

  final bool ok;
  final String? message;

  factory CompleteTaskResponseDto.fromJson(Map<String, dynamic> json) {
    return CompleteTaskResponseDto(
      ok: json['ok'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}
