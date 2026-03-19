import '../entities/create_activity_input.dart';
import '../repositories/activities_repository.dart';

class CreateActivityUseCase {
  const CreateActivityUseCase(this._repository);

  final ActivitiesRepository _repository;

  Future<void> call(CreateActivityInput input) {
    return _repository.createActivity(input);
  }
}
