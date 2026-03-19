class UpdateOrderStatusRequestDto {
  const UpdateOrderStatusRequestDto({
    required this.orderId,
    required this.status,
  });

  final String orderId;
  final String status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'status': status};
  }
}
