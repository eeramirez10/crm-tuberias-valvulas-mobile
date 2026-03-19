import '../../domain/entities/create_activity_input.dart';
import '../../domain/entities/activity_item.dart';
import '../../domain/repositories/activities_repository.dart';
import '../datasources/activities_datasource.dart';
import '../dtos/create_activity_request_dto.dart';

class ActivitiesRepositoryImpl implements ActivitiesRepository {
  const ActivitiesRepositoryImpl(this._datasource);

  final ActivitiesDatasource _datasource;

  @override
  Future<List<ActivityItem>> getActivities() async {
    final dto = await _datasource.getActivities();
    return dto.items.map((item) => item.toEntity()).toList(growable: false);
  }

  @override
  Future<void> createActivity(CreateActivityInput input) async {
    final response = await _datasource.createActivity(
      CreateActivityRequestDto.fromInput(input),
    );

    if (!response.ok) {
      throw StateError(
        response.message ?? 'No se pudo registrar la actividad.',
      );
    }
  }
}
