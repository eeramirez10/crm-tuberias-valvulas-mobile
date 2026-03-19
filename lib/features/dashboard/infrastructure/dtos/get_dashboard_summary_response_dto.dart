import '../../domain/entities/dashboard_summary.dart';

class DashboardTopQuotedProductDto {
  const DashboardTopQuotedProductDto({
    required this.productName,
    required this.quantity,
  });

  final String productName;
  final int quantity;

  factory DashboardTopQuotedProductDto.fromJson(Map<String, dynamic> json) {
    return DashboardTopQuotedProductDto(
      productName: json['product_name'] as String? ?? 'Producto',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }

  DashboardTopQuotedProduct toEntity() {
    return DashboardTopQuotedProduct(
      productName: productName,
      quantity: quantity,
    );
  }
}

class GetDashboardSummaryResponseDto {
  const GetDashboardSummaryResponseDto({
    required this.totalCustomers,
    required this.activeLeads,
    required this.pipelineValue,
    required this.openTasks,
    required this.wonThisMonth,
    required this.conversionRate,
    required this.quotesThisMonth,
    required this.quotesApprovalRate,
    required this.quotesApprovedAmount,
    required this.topQuotedProducts,
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
  final List<DashboardTopQuotedProductDto> topQuotedProducts;

  factory GetDashboardSummaryResponseDto.fromJson(Map<String, dynamic> json) {
    return GetDashboardSummaryResponseDto(
      totalCustomers: (json['total_customers'] as num?)?.toInt() ?? 0,
      activeLeads: (json['active_leads'] as num?)?.toInt() ?? 0,
      pipelineValue: (json['pipeline_value'] as num?)?.toDouble() ?? 0,
      openTasks: (json['open_tasks'] as num?)?.toInt() ?? 0,
      wonThisMonth: (json['won_this_month'] as num?)?.toDouble() ?? 0,
      conversionRate: (json['conversion_rate'] as num?)?.toDouble() ?? 0,
      quotesThisMonth: (json['quotes_this_month'] as num?)?.toInt() ?? 0,
      quotesApprovalRate:
          (json['quotes_approval_rate'] as num?)?.toDouble() ?? 0,
      quotesApprovedAmount:
          (json['quotes_approved_amount'] as num?)?.toDouble() ?? 0,
      topQuotedProducts:
          (json['top_quoted_products'] as List<dynamic>? ?? <dynamic>[])
              .whereType<Map<String, dynamic>>()
              .map(DashboardTopQuotedProductDto.fromJson)
              .toList(growable: false),
    );
  }

  DashboardSummary toEntity() {
    return DashboardSummary(
      totalCustomers: totalCustomers,
      activeLeads: activeLeads,
      pipelineValue: pipelineValue,
      openTasks: openTasks,
      wonThisMonth: wonThisMonth,
      conversionRate: conversionRate,
      quotesThisMonth: quotesThisMonth,
      quotesApprovalRate: quotesApprovalRate,
      quotesApprovedAmount: quotesApprovedAmount,
      topQuotedProducts: topQuotedProducts
          .map((item) => item.toEntity())
          .toList(growable: false),
    );
  }
}
