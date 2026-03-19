import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/http_adapter.dart';
import '../../../../core/network/http_method.dart';
import '../dtos/create_activity_request_dto.dart';
import '../dtos/create_activity_response_dto.dart';
import '../dtos/get_activities_response_dto.dart';

class ActivitiesDatasource {
  const ActivitiesDatasource(this._httpAdapter);

  final HttpAdapter _httpAdapter;

  Future<GetActivitiesResponseDto> getActivities() async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.activities,
      method: HttpMethod.get,
    );

    return GetActivitiesResponseDto.fromJson(response);
  }

  Future<CreateActivityResponseDto> createActivity(
    CreateActivityRequestDto request,
  ) async {
    final response = await _httpAdapter.request(
      path: ApiEndpoints.activities,
      method: HttpMethod.post,
      data: request.toJson(),
    );

    return CreateActivityResponseDto.fromJson(response);
  }
}
