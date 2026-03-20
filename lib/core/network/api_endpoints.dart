class ApiEndpoints {
  const ApiEndpoints._();

  static const dashboardSummary = '/dashboard/summary';
  static const customers = '/customers';
  static const products = '/products';
  static const leads = '/leads';
  static const opportunities = '/opportunities';
  static const quotes = '/quotes';
  static const orders = '/orders';
  static const tasks = '/tasks';
  static const activities = '/activities';
  static const aiInsights = '/ai/insights';
  static const aiNextActions = '/ai/next-actions';
  static const aiRiskSummary = '/ai/risk-summary';
  static const aiFollowUpDraft = '/ai/follow-up-draft';

  static String leadById(String id) => '$leads/$id';
  static String updateOpportunityStage(String id) => '$opportunities/$id/stage';
  static String quoteById(String id) => '$quotes/$id';
  static String updateQuoteStatus(String id) => '$quotes/$id/status';
  static String convertQuoteToOrder(String id) => '$quotes/$id/convert-order';
  static String orderById(String id) => '$orders/$id';
  static String updateOrderStatus(String id) => '$orders/$id/status';
  static String completeTask(String id) => '$tasks/$id/complete';
}
