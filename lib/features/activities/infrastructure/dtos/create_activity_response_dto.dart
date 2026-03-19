class CreateActivityResponseDto {
  const CreateActivityResponseDto({required this.ok, this.message});

  final bool ok;
  final String? message;

  factory CreateActivityResponseDto.fromJson(Map<String, dynamic> json) {
    return CreateActivityResponseDto(
      ok: json['ok'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}
