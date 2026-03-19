class UpdateQuoteStatusResponseDto {
  const UpdateQuoteStatusResponseDto({required this.ok, this.message});

  final bool ok;
  final String? message;

  factory UpdateQuoteStatusResponseDto.fromJson(Map<String, dynamic> json) {
    return UpdateQuoteStatusResponseDto(
      ok: json['ok'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }
}
