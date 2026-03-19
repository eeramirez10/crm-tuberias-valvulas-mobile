import '../entities/create_activity_input.dart';
import '../entities/activity_item.dart';

abstract class ActivitiesRepository {
  Future<List<ActivityItem>> getActivities();
  Future<void> createActivity(CreateActivityInput input);
}
