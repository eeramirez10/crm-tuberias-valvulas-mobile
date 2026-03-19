class UpdateOrderStatusResponseDto {
  const UpdateOrderStatusResponseDto({required this.ok, this.message});

  final bool ok;
  final String? message;

  factory UpdateOrderStatusResponseDto.fromJson(Map<String, dynamic> json) {
    return UpdateOrderStatusResponseDto(
      ok: json['ok'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}
