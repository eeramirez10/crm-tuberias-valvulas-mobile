import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_adapter.dart';
import '../../../../core/network/http_method.dart';
import '../dtos/complete_task_request_dto.dart';
import '../dtos/complete_task_response_dto.dart';
import '../dtos/create_task_request_dto.dart';
import '../dtos/create_task_response_dto.dart';
import '../dtos/get_tasks_request_dto.dart';
import '../dtos/get_tasks_response_dto.dart';

class TasksDatasource {
  const TasksDatasource(this._httpAdapter);

  final HttpAdapter _httpAdapter;

  Future<GetTasksResponseDto> getTasks(GetTasksRequestDto request) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.tasks,
      method: HttpMethod.get,
      queryParameters: request.toQueryParameters(),
    );

    return GetTasksResponseDto.fromJson(response);
  }

  Future<CompleteTaskResponseDto> completeTask(
    CompleteTaskRequestDto request,
  ) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.completeTask(request.taskId),
      method: HttpMethod.patch,
    );

    return CompleteTaskResponseDto.fromJson(response);
  }

  Future<CreateTaskResponseDto> createTask(CreateTaskRequestDto request) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.tasks,
      method: HttpMethod.post,
      data: request.toJson(),
    );

    return CreateTaskResponseDto.fromJson(response);
  }
}
