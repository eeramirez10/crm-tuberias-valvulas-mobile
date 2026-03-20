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

    if (path == ApiEndpoints.products && method == HttpMethod.get) {
      return _dataStore.getProducts(
        query: queryParameters?['q'] as String?,
        category: queryParameters?['category'] as String?,
      );
    }

    if (path == ApiEndpoints.leads && method == HttpMethod.get) {
      return _dataStore.getLeads(status: queryParameters?['status'] as String?);
    }

    if (path == ApiEndpoints.leads && method == HttpMethod.post) {
      return _dataStore.createLead(
        companyName: (data?['company_name'] as String?) ?? '',
        contactName: (data?['contact_name'] as String?) ?? '',
        contactPhone: (data?['contact_phone'] as String?) ?? '',
        contactEmail: (data?['contact_email'] as String?) ?? '',
        source: (data?['source'] as String?) ?? '',
        status: (data?['status'] as String?) ?? '',
        estimatedAmount: (data?['estimated_amount'] as num?)?.toDouble() ?? 0,
        nextActionDate: (data?['next_action_date'] as String?) ?? '',
        owner: (data?['owner'] as String?) ?? '',
        notes: (data?['notes'] as String?) ?? '',
      );
    }

    if (path.startsWith('${ApiEndpoints.leads}/') &&
        method == HttpMethod.patch) {
      final segments = path.split('/');
      final id = segments[2];
      return _dataStore.updateLead(
        leadId: id,
        companyName: (data?['company_name'] as String?) ?? '',
        contactName: (data?['contact_name'] as String?) ?? '',
        contactPhone: (data?['contact_phone'] as String?) ?? '',
        contactEmail: (data?['contact_email'] as String?) ?? '',
        source: (data?['source'] as String?) ?? '',
        status: (data?['status'] as String?) ?? '',
        estimatedAmount: (data?['estimated_amount'] as num?)?.toDouble() ?? 0,
        nextActionDate: (data?['next_action_date'] as String?) ?? '',
        owner: (data?['owner'] as String?) ?? '',
        notes: (data?['notes'] as String?) ?? '',
      );
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

    if (path == ApiEndpoints.quotes && method == HttpMethod.get) {
      return _dataStore.getQuotes(
        status: queryParameters?['status'] as String?,
      );
    }

    if (path == ApiEndpoints.quotes && method == HttpMethod.post) {
      final rawLines = (data?['lines'] as List<dynamic>? ?? <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .toList(growable: false);
      return _dataStore.createQuote(
        customerName: (data?['customer_name'] as String?) ?? '',
        relatedType: (data?['related_type'] as String?) ?? 'lead',
        relatedId: (data?['related_id'] as String?) ?? '',
        lines: rawLines,
        taxRate: (data?['tax_rate'] as num?)?.toDouble() ?? 0.16,
        validUntil: (data?['valid_until'] as String?) ?? '',
      );
    }

    if (path.startsWith('${ApiEndpoints.quotes}/') &&
        !path.endsWith('/status') &&
        !path.endsWith('/convert-order') &&
        method == HttpMethod.get) {
      final segments = path.split('/');
      final id = segments[2];
      return _dataStore.getQuoteById(id);
    }

    if (path.startsWith('${ApiEndpoints.quotes}/') &&
        path.endsWith('/status') &&
        method == HttpMethod.patch) {
      final segments = path.split('/');
      final id = segments[2];
      return _dataStore.updateQuoteStatus(
        id: id,
        status: (data?['status'] as String?) ?? '',
      );
    }

    if (path.startsWith('${ApiEndpoints.quotes}/') &&
        path.endsWith('/convert-order') &&
        method == HttpMethod.post) {
      final segments = path.split('/');
      final id = segments[2];
      return _dataStore.convertQuoteToOrder(id);
    }

    if (path == ApiEndpoints.orders && method == HttpMethod.get) {
      return _dataStore.getOrders(
        status: queryParameters?['status'] as String?,
      );
    }

    if (path.startsWith('${ApiEndpoints.orders}/') &&
        !path.endsWith('/status') &&
        method == HttpMethod.get) {
      final segments = path.split('/');
      final id = segments[2];
      return _dataStore.getOrderById(id);
    }

    if (path.startsWith('${ApiEndpoints.orders}/') &&
        path.endsWith('/status') &&
        method == HttpMethod.patch) {
      final segments = path.split('/');
      final id = segments[2];
      return _dataStore.updateOrderStatus(
        id: id,
        status: (data?['status'] as String?) ?? '',
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

    if (path == ApiEndpoints.aiNextActions && method == HttpMethod.get) {
      return _dataStore.getAiNextActions();
    }

    if (path == ApiEndpoints.aiRiskSummary && method == HttpMethod.get) {
      return _dataStore.getAiRiskSummary();
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
