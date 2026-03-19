class ApiEndpoints {
  const ApiEndpoints._();

  static const dashboardSummary = '/dashboard/summary';
  static const customers = '/customers';
  static const leads = '/leads';
  static const opportunities = '/opportunities';
  static const tasks = '/tasks';
  static const activities = '/activities';
  static const aiInsights = '/ai/insights';
  static const aiFollowUpDraft = '/ai/follow-up-draft';

  static String updateOpportunityStage(String id) => '$opportunities/$id/stage';
  static String completeTask(String id) => '$tasks/$id/complete';
}
