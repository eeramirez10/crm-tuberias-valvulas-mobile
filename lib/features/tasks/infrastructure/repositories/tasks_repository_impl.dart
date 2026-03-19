import '../../domain/entities/create_task_input.dart';
import '../../domain/entities/task_item.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_datasource.dart';
import '../dtos/complete_task_request_dto.dart';
import '../dtos/create_task_request_dto.dart';
import '../dtos/get_tasks_request_dto.dart';

class TasksRepositoryImpl implements TasksRepository {
  const TasksRepositoryImpl(this._datasource);

  final TasksDatasource _datasource;

  @override
  Future<List<TaskItem>> getTasks({bool? completed}) async {
    final dto = await _datasource.getTasks(
      GetTasksRequestDto(completed: completed),
    );
    return dto.items.map((item) => item.toEntity()).toList(growable: false);
  }

  @override
  Future<void> completeTask(String taskId) async {
    final response = await _datasource.completeTask(
      CompleteTaskRequestDto(taskId: taskId),
    );

    if (!response.ok) {
      throw StateError(
        response.message ?? 'No fue posible completar la tarea.',
      );
    }
  }

  @override
  Future<void> createTask(CreateTaskInput input) async {
    final response = await _datasource.createTask(
      CreateTaskRequestDto.fromInput(input),
    );

    if (!response.ok) {
      throw StateError(response.message ?? 'No fue posible crear la tarea.');
    }
  }
}
