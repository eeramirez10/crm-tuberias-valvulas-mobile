class ActivityItem {
  const ActivityItem({
    required this.id,
    required this.type,
    required this.summary,
    required this.owner,
    required this.createdAt,
  });

  final String id;
  final String type;
  final String summary;
  final String owner;
  final DateTime createdAt;
}
