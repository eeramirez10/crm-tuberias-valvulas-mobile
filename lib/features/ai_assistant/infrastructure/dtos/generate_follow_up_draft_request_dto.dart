class GenerateFollowUpDraftRequestDto {
  const GenerateFollowUpDraftRequestDto({
    required this.customerName,
    required this.context,
    required this.channel,
  });

  final String customerName;
  final String context;
  final String channel;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'customer_name': customerName,
      'context': context,
      'channel': channel,
    };
  }
}
