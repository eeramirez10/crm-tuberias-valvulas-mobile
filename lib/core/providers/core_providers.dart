import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/dio_http_adapter.dart';
import '../network/http_adapter.dart';
import '../network/mock_api_data_store.dart';
import '../network/mock_http_adapter.dart';

part 'core_providers.g.dart';

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://api.crm-demo.local',
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
    ),
  );
}

@Riverpod(keepAlive: true)
MockApiDataStore mockApiDataStore(Ref ref) {
  return MockApiDataStore.seeded();
}

@Riverpod(keepAlive: true)
HttpAdapter httpAdapter(Ref ref) {
  final store = ref.watch(mockApiDataStoreProvider);
  return MockHttpAdapter(dataStore: store);
}

@Riverpod(keepAlive: true)
DioHttpAdapter dioHttpAdapter(Ref ref) {
  return DioHttpAdapter(ref.watch(dioProvider));
}
