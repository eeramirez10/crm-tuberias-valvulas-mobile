import '../entities/task_item.dart';
import '../repositories/tasks_repository.dart';

class GetTasksUseCase {
  const GetTasksUseCase(this._repository);

  final TasksRepository _repository;

  Future<List<TaskItem>> call({bool? completed}) {
    return _repository.getTasks(completed: completed);
  }
}
