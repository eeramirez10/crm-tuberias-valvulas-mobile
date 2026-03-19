import 'dart:async';

import 'api_endpoints.dart';
import 'http_adapter.dart';
import 'http_method.dart';
import 'mock_api_data_store.dart';

class MockHttpAdapter implements HttpAdapter {
  MockHttpAdapter({required MockApiDataStore dataStore})
    : _dataStore = dataStore;

  final MockApiDataStore _dataStore;

  @override
  Future<Map<String, dynamic>> request({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));

    if (path == ApiEndpoints.dashboardSummary && method == HttpMethod.get) {
      return _dataStore.getDashboardSummary();
    }

    if (path == ApiEndpoints.customers && method == HttpMethod.get) {
      return _dataStore.getCustomers(query: queryParameters?['q'] as String?);
    }

    if (path == ApiEndpoints.leads && method == HttpMethod.get) {
      return _dataStore.getLeads(status: queryParameters?['status'] as String?);
    }

    if (path == ApiEndpoints.opportunities && method == HttpMethod.get) {
      return _dataStore.getOpportunities(
        stage: queryParameters?['stage'] as String?,
      );
    }

    if (path.startsWith('${ApiEndpoints.opportunities}/') &&
        path.endsWith('/stage') &&
        method == HttpMethod.patch) {
      final segments = path.split('/');
      final id = segments[2];
      return _dataStore.updateOpportunityStage(
        id: id,
        stage: (data?['stage'] as String?) ?? '',
      );
    }

    if (path == ApiEndpoints.tasks && method == HttpMethod.get) {
      return _dataStore.getTasks(
        completed: queryParameters?['completed'] as bool?,
      );
    }

    if (path == ApiEndpoints.tasks && method == HttpMethod.post) {
      return _dataStore.createTask(
        title: (data?['title'] as String?) ?? '',
        type: (data?['type'] as String?) ?? 'Seguimiento',
        dueDate: (data?['due_date'] as String?) ?? '',
        relatedTo: (data?['related_to'] as String?) ?? '',
      );
    }

    if (path.startsWith('${ApiEndpoints.tasks}/') &&
        path.endsWith('/complete') &&
        method == HttpMethod.patch) {
      final segments = path.split('/');
      final id = segments[2];
      return _dataStore.completeTask(id);
    }

    if (path == ApiEndpoints.activities && method == HttpMethod.get) {
      return _dataStore.getActivities();
    }

    if (path == ApiEndpoints.activities && method == HttpMethod.post) {
      return _dataStore.createActivity(
        type: (data?['type'] as String?) ?? '',
        summary: (data?['summary'] as String?) ?? '',
        owner: (data?['owner'] as String?) ?? '',
      );
    }

    if (path == ApiEndpoints.aiInsights && method == HttpMethod.get) {
      return _dataStore.getAiInsights();
    }

    if (path == ApiEndpoints.aiFollowUpDraft && method == HttpMethod.post) {
      return _dataStore.generateFollowUpDraft(
        customerName: (data?['customer_name'] as String?) ?? 'Cliente',
        context: (data?['context'] as String?) ?? '',
        channel: (data?['channel'] as String?) ?? 'whatsapp',
      );
    }

    throw UnsupportedError(
      'Mock endpoint no implementado: ${method.name} $path',
    );
  }
}
