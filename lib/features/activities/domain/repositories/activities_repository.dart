import '../entities/activity_item.dart';

abstract class ActivitiesRepository {
  Future<List<ActivityItem>> getActivities();
}
