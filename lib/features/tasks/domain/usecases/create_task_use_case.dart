import '../entities/create_task_input.dart';
import '../repositories/tasks_repository.dart';

class CreateTaskUseCase {
  const CreateTaskUseCase(this._repository);

  final TasksRepository _repository;

  Future<void> call(CreateTaskInput input) {
    return _repository.createTask(input);
  }
}
