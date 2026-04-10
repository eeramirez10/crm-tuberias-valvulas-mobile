class DashboardTopQuotedProduct {
  const DashboardTopQuotedProduct({
    required this.productName,
    required this.quantity,
  });

  final String productName;
  final int quantity;
}

class DashboardSummary {
  const DashboardSummary({
    required this.totalCustomers,
    required this.activeLeads,
    required this.pipelineValue,
    required this.openTasks,
    required this.wonThisMonth,
    required this.conversionRate,
    required this.quotesThisMonth,
    required this.quotesApprovalRate,
    required this.quotesApprovedAmount,
    required this.ordersThisMonth,
    required this.ordersOnTimeRate,
    required this.ordersBacklog,
    required this.topQuotedProducts,
    required this.highValueInactiveQuotesCount,
    required this.highValueInactiveQuotesAmount,
    required this.lostDealsTotal,
    required this.lostDealsByPrice,
    required this.lostDealsByStock,
    required this.lostDealsByDelivery,
    required this.lostDealsByTechnical,
  });

  final int totalCustomers;
  final int activeLeads;
  final double pipelineValue;
  final int openTasks;
  final double wonThisMonth;
  final double conversionRate;
  final int quotesThisMonth;
  final double quotesApprovalRate;
  final double quotesApprovedAmount;
  final int ordersThisMonth;
  final double ordersOnTimeRate;
  final int ordersBacklog;
  final List<DashboardTopQuotedProduct> topQuotedProducts;
  final int highValueInactiveQuotesCount;
  final double highValueInactiveQuotesAmount;
  final int lostDealsTotal;
  final int lostDealsByPrice;
  final int lostDealsByStock;
  final int lostDealsByDelivery;
  final int lostDealsByTechnical;
}
