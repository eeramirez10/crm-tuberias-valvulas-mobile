enum QuoteStatus { draft, sent, approved, rejected, converted }

extension QuoteStatusX on QuoteStatus {
  String get code {
    switch (this) {
      case QuoteStatus.draft:
        return 'Borrador';
      case QuoteStatus.sent:
        return 'Enviada';
      case QuoteStatus.approved:
        return 'Aprobada';
      case QuoteStatus.rejected:
        return 'Rechazada';
      case QuoteStatus.converted:
        return 'Convertida';
    }
  }

  String get label => code;

  static QuoteStatus fromCode(String value) {
    for (final status in QuoteStatus.values) {
      if (status.code.toLowerCase() == value.toLowerCase()) {
        return status;
      }
    }

    return QuoteStatus.draft;
  }
}

class Quote {
  const Quote({
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
  });

  final String id;
  final String code;
  final String customerName;
  final String relatedType;
  final String relatedId;
  final QuoteStatus status;
  final int itemsCount;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final String validUntil;
  final String createdAt;
}
