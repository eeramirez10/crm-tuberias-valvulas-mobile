import '../repositories/tasks_repository.dart';

class CompleteTaskUseCase {
  const CompleteTaskUseCase(this._repository);

  final TasksRepository _repository;

  Future<void> call(String taskId) {
    return _repository.completeTask(taskId);
  }
}
