class Lead {
  const Lead({
    required this.id,
    required this.companyName,
    required this.source,
    required this.status,
    required this.estimatedAmount,
    required this.nextActionDate,
    required this.owner,
  });

  final String id;
  final String companyName;
  final String source;
  final String status;
  final double estimatedAmount;
  final String nextActionDate;
  final String owner;
}
