import '../../domain/entities/activity_item.dart';
import '../../domain/repositories/activities_repository.dart';
import '../datasources/activities_datasource.dart';

class ActivitiesRepositoryImpl implements ActivitiesRepository {
  const ActivitiesRepositoryImpl(this._datasource);

  final ActivitiesDatasource _datasource;

  @override
  Future<List<ActivityItem>> getActivities() async {
    final dto = await _datasource.getActivities();
    return dto.items.map((item) => item.toEntity()).toList(growable: false);
  }
}
