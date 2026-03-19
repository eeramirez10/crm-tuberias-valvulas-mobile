import 'package:dio/dio.dart';

import 'http_adapter.dart';
import 'http_method.dart';

class DioHttpAdapter implements HttpAdapter {
  DioHttpAdapter(this._dio);

  final Dio _dio;

  @override
  Future<Map<String, dynamic>> request({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) async {
    final response = await _dio.request<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(method: method.name.toUpperCase()),
    );

    return response.data ?? <String, dynamic>{};
  }
}
