enum OpportunityStage {
  newLead,
  contacted,
  requirement,
  quotation,
  negotiation,
  won,
  lost,
}

extension OpportunityStageX on OpportunityStage {
  String get code {
    switch (this) {
      case OpportunityStage.newLead:
        return 'Nuevo Lead';
      case OpportunityStage.contacted:
        return 'Contactado';
      case OpportunityStage.requirement:
        return 'Requerimiento';
      case OpportunityStage.quotation:
        return 'Cotizacion';
      case OpportunityStage.negotiation:
        return 'Negociacion';
      case OpportunityStage.won:
        return 'Ganada';
      case OpportunityStage.lost:
        return 'Perdida';
    }
  }

  String get label => code;

  static OpportunityStage fromCode(String value) {
    for (final stage in OpportunityStage.values) {
      if (stage.code.toLowerCase() == value.toLowerCase()) {
        return stage;
      }
    }

    return OpportunityStage.newLead;
  }
}

class Opportunity {
  const Opportunity({
    required this.id,
    required this.customerName,
    required this.title,
    required this.stage,
    required this.amount,
    required this.probability,
    required this.expectedCloseDate,
  });

  final String id;
  final String customerName;
  final String title;
  final OpportunityStage stage;
  final double amount;
  final double probability;
  final String expectedCloseDate;
}
