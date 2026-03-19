import '../../domain/entities/ai_risk_summary.dart';

class GetAiRiskSummaryResponseDto {
  const GetAiRiskSummaryResponseDto({
    required this.high,
    required this.medium,
    required this.low,
  });

  final int high;
  final int medium;
  final int low;

  factory GetAiRiskSummaryResponseDto.fromJson(Map<String, dynamic> json) {
    return GetAiRiskSummaryResponseDto(
      high: (json['high'] as num?)?.toInt() ?? 0,
      medium: (json['medium'] as num?)?.toInt() ?? 0,
      low: (json['low'] as num?)?.toInt() ?? 0,
    );
  }

  AiRiskSummary toEntity() {
    return AiRiskSummary(high: high, medium: medium, low: low);
  }
}
