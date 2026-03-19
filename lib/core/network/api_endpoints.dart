class ApiEndpoints {
  const ApiEndpoints._();

  static const dashboardSummary = '/dashboard/summary';
  static const customers = '/customers';
  static const products = '/products';
  static const leads = '/leads';
  static const opportunities = '/opportunities';
  static const quotes = '/quotes';
  static const tasks = '/tasks';
  static const activities = '/activities';
  static const aiInsights = '/ai/insights';
  static const aiNextActions = '/ai/next-actions';
  static const aiRiskSummary = '/ai/risk-summary';
  static const aiFollowUpDraft = '/ai/follow-up-draft';

  static String updateOpportunityStage(String id) => '$opportunities/$id/stage';
  static String quoteById(String id) => '$quotes/$id';
  static String updateQuoteStatus(String id) => '$quotes/$id/status';
  static String convertQuoteToOrder(String id) => '$quotes/$id/convert-order';
  static String completeTask(String id) => '$tasks/$id/complete';
}
