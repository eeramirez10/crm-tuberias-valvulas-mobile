import '../../domain/entities/quote.dart';
import 'quote_line_item_dto.dart';

class QuoteItemDto {
  const QuoteItemDto({
    required this.id,
    required this.code,
    required this.customerName,
    required this.relatedType,
    required this.relatedId,
    required this.status,
    required this.itemsCount,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.validUntil,
    required this.createdAt,
    required this.marginRate,
    required this.lines,
  });

  final String id;
  final String code;
  final String customerName;
  final String relatedType;
  final String relatedId;
  final String status;
  final int itemsCount;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final String validUntil;
  final String createdAt;
  final double marginRate;
  final List<QuoteLineItemDto> lines;

  factory QuoteItemDto.fromJson(Map<String, dynamic> json) {
    final rawLines = (json['lines'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    return QuoteItemDto(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      customerName: json['customer_name'] as String? ?? '',
      relatedType: json['related_type'] as String? ?? '',
      relatedId: json['related_id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0,
      validUntil: json['valid_until'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      marginRate: (json['margin_rate'] as num?)?.toDouble() ?? 0,
      lines: rawLines.map(QuoteLineItemDto.fromJson).toList(growable: false),
    );
  }

  Quote toEntity() {
    return Quote(
      id: id,
      code: code,
      customerName: customerName,
      relatedType: relatedType,
      relatedId: relatedId,
      status: QuoteStatusX.fromCode(status),
      itemsCount: itemsCount,
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      total: total,
      validUntil: validUntil,
      createdAt: createdAt,
      marginRate: marginRate,
      lines: lines.map((line) => line.toEntity()).toList(growable: false),
    );
  }
}
