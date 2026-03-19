import '../entities/task_item.dart';

abstract class TasksRepository {
  Future<List<TaskItem>> getTasks({bool? completed});
  Future<void> completeTask(String taskId);
}
