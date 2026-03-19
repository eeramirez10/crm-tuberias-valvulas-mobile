import '../entities/activity_item.dart';
import '../repositories/activities_repository.dart';

class GetActivitiesUseCase {
  const GetActivitiesUseCase(this._repository);

  final ActivitiesRepository _repository;

  Future<List<ActivityItem>> call() {
    return _repository.getActivities();
  }
}
