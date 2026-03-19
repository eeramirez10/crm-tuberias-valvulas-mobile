import 'http_method.dart';

abstract class HttpAdapter {
  Future<Map<String, dynamic>> request({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  });
}
