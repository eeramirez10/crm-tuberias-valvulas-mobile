import 'dart:math';

import '../../features/opportunities/domain/entities/opportunity.dart';

class MockApiDataStore {
  MockApiDataStore._({
    required List<Map<String, dynamic>> customers,
    required List<Map<String, dynamic>> leads,
    required List<Map<String, dynamic>> opportunities,
    required List<Map<String, dynamic>> tasks,
    required List<Map<String, dynamic>> activities,
  }) : _customers = customers,
       _leads = leads,
       _opportunities = opportunities,
       _tasks = tasks,
       _activities = activities;

  factory MockApiDataStore.seeded() {
    return MockApiDataStore._(
      customers: <Map<String, dynamic>>[
        {
          'id': 'cus-001',
          'name': 'Constructora del Golfo',
          'segment': 'Construccion',
          'contact_name': 'Carlos Mendez',
          'contact_phone': '+52 229 100 2001',
          'city': 'Veracruz',
          'credit_status': 'Aprobado',
        },
        {
          'id': 'cus-002',
          'name': 'Mantenimiento Industrial Norte',
          'segment': 'Industria',
          'contact_name': 'Laura Salinas',
          'contact_phone': '+52 818 500 3401',
          'city': 'Monterrey',
          'credit_status': 'Revision',
        },
        {
          'id': 'cus-003',
          'name': 'Servicios Hidraulicos del Centro',
          'segment': 'Mantenimiento',
          'contact_name': 'Diego Carranza',
          'contact_phone': '+52 222 150 7780',
          'city': 'Puebla',
          'credit_status': 'Aprobado',
        },
      ],
      leads: <Map<String, dynamic>>[
        {
          'id': 'lead-001',
          'company_name': 'Planta Embotelladora Delta',
          'source': 'Referido',
          'status': 'Nuevo',
          'estimated_amount': 185000.0,
          'next_action_date': '2026-03-20',
          'owner': 'Erick Ramirez',
        },
        {
          'id': 'lead-002',
          'company_name': 'Hotel Marina Azul',
          'source': 'Visita',
          'status': 'Contactado',
          'estimated_amount': 52000.0,
          'next_action_date': '2026-03-19',
          'owner': 'Erick Ramirez',
        },
        {
          'id': 'lead-003',
          'company_name': 'Obra Periferico Sur Tramo 2',
          'source': 'Llamada',
          'status': 'Calificado',
          'estimated_amount': 430000.0,
          'next_action_date': '2026-03-22',
          'owner': 'Mariana Solis',
        },
      ],
      opportunities: <Map<String, dynamic>>[
        {
          'id': 'opp-001',
          'customer_name': 'Constructora del Golfo',
          'title': 'Tuberia c40 4 pulgadas',
          'stage': OpportunityStage.quotation.code,
          'amount': 220000.0,
          'probability': 0.65,
          'expected_close_date': '2026-03-29',
        },
        {
          'id': 'opp-002',
          'customer_name': 'Mantenimiento Industrial Norte',
          'title': 'Valvula compuerta acero 2 pulgadas',
          'stage': OpportunityStage.negotiation.code,
          'amount': 94000.0,
          'probability': 0.75,
          'expected_close_date': '2026-03-25',
        },
        {
          'id': 'opp-003',
          'customer_name': 'Servicios Hidraulicos del Centro',
          'title': 'Paquete conexiones galvanizadas',
          'stage': OpportunityStage.requirement.code,
          'amount': 48000.0,
          'probability': 0.4,
          'expected_close_date': '2026-04-05',
        },
      ],
      tasks: <Map<String, dynamic>>[
        {
          'id': 'task-001',
          'title': 'Llamar para confirmar especificaciones ASTM',
          'type': 'Llamada',
          'due_date': '2026-03-19',
          'related_to': 'opp-001',
          'completed': false,
        },
        {
          'id': 'task-002',
          'title': 'Enviar cotizacion version 2',
          'type': 'Cotizacion',
          'due_date': '2026-03-20',
          'related_to': 'opp-002',
          'completed': false,
        },
        {
          'id': 'task-003',
          'title': 'Agendar visita tecnica en planta',
          'type': 'Visita',
          'due_date': '2026-03-21',
          'related_to': 'lead-003',
          'completed': false,
        },
      ],
      activities: <Map<String, dynamic>>[
        {
          'id': 'act-001',
          'type': 'Llamada',
          'summary': 'Cliente solicito fichas tecnicas de valvulas ANSI 150.',
          'owner': 'Erick Ramirez',
          'created_at': '2026-03-19T09:10:00Z',
        },
        {
          'id': 'act-002',
          'type': 'Nota',
          'summary':
              'Se detecta oportunidad de cross-sell con conexiones bridadas.',
          'owner': 'Mariana Solis',
          'created_at': '2026-03-19T10:35:00Z',
        },
        {
          'id': 'act-003',
          'type': 'Visita',
          'summary': 'Se revisaron medidas reales de instalacion en sitio.',
          'owner': 'Erick Ramirez',
          'created_at': '2026-03-18T17:15:00Z',
        },
      ],
    );
  }

  final List<Map<String, dynamic>> _customers;
  final List<Map<String, dynamic>> _leads;
  final List<Map<String, dynamic>> _opportunities;
  final List<Map<String, dynamic>> _tasks;
  final List<Map<String, dynamic>> _activities;

  Map<String, dynamic> getDashboardSummary() {
    final pipelineValue = _opportunities.fold<double>(
      0,
      (sum, item) => sum + (item['amount'] as num).toDouble(),
    );

    final openTasks = _tasks
        .where((task) => task['completed'] as bool == false)
        .length;

    return <String, dynamic>{
      'total_customers': _customers.length,
      'active_leads': _leads.length,
      'pipeline_value': pipelineValue,
      'open_tasks': openTasks,
      'won_this_month': 312000.0,
      'conversion_rate': 0.31,
    };
  }

  Map<String, dynamic> getCustomers({String? query}) {
    if (query == null || query.trim().isEmpty) {
      return <String, dynamic>{'items': _customers};
    }

    final normalizedQuery = query.toLowerCase().trim();
    final filtered = _customers
        .where(
          (item) =>
              (item['name'] as String).toLowerCase().contains(normalizedQuery),
        )
        .toList(growable: false);

    return <String, dynamic>{'items': filtered};
  }

  Map<String, dynamic> getLeads({String? status}) {
    if (status == null || status.isEmpty) {
      return <String, dynamic>{'items': _leads};
    }

    final filtered = _leads
        .where((lead) => lead['status'] == status)
        .toList(growable: false);
    return <String, dynamic>{'items': filtered};
  }

  Map<String, dynamic> getOpportunities({String? stage}) {
    if (stage == null || stage.isEmpty) {
      return <String, dynamic>{'items': _opportunities};
    }

    final filtered = _opportunities
        .where((item) => item['stage'] == stage)
        .toList(growable: false);
    return <String, dynamic>{'items': filtered};
  }

  Map<String, dynamic> updateOpportunityStage({
    required String id,
    required String stage,
  }) {
    final index = _opportunities.indexWhere((item) => item['id'] == id);
    if (index == -1) {
      return <String, dynamic>{
        'ok': false,
        'message': 'Oportunidad no encontrada.',
      };
    }

    _opportunities[index] = <String, dynamic>{
      ..._opportunities[index],
      'stage': stage,
      'probability': min(
        0.95,
        (_opportunities[index]['probability'] as num) + 0.05,
      ),
    };

    return <String, dynamic>{'ok': true};
  }

  Map<String, dynamic> getTasks({bool? completed}) {
    if (completed == null) {
      return <String, dynamic>{'items': _tasks};
    }

    final filtered = _tasks
        .where((task) => task['completed'] == completed)
        .toList(growable: false);
    return <String, dynamic>{'items': filtered};
  }

  Map<String, dynamic> completeTask(String id) {
    final index = _tasks.indexWhere((task) => task['id'] == id);
    if (index == -1) {
      return <String, dynamic>{'ok': false, 'message': 'Tarea no encontrada.'};
    }

    _tasks[index] = <String, dynamic>{..._tasks[index], 'completed': true};
    return <String, dynamic>{'ok': true};
  }

  Map<String, dynamic> createTask({
    required String title,
    required String type,
    required String dueDate,
    required String relatedTo,
  }) {
    if (title.trim().isEmpty || relatedTo.trim().isEmpty) {
      return <String, dynamic>{
        'ok': false,
        'message': 'Titulo y relacionado son obligatorios.',
      };
    }

    final id = 'task-${DateTime.now().microsecondsSinceEpoch}';
    _tasks.insert(0, <String, dynamic>{
      'id': id,
      'title': title.trim(),
      'type': type.trim().isEmpty ? 'Seguimiento' : type.trim(),
      'due_date': dueDate.trim().isEmpty ? '2026-03-20' : dueDate.trim(),
      'related_to': relatedTo.trim(),
      'completed': false,
    });

    _activities.insert(0, <String, dynamic>{
      'id': 'act-${DateTime.now().millisecondsSinceEpoch}',
      'type': 'Tarea',
      'summary': 'Nueva tarea creada: $title',
      'owner': 'Erick Ramirez',
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });

    return <String, dynamic>{'ok': true};
  }

  Map<String, dynamic> getActivities() {
    return <String, dynamic>{'items': _activities};
  }

  Map<String, dynamic> createActivity({
    required String type,
    required String summary,
    required String owner,
  }) {
    if (summary.trim().isEmpty) {
      return <String, dynamic>{
        'ok': false,
        'message': 'El resumen de actividad es obligatorio.',
      };
    }

    _activities.insert(0, <String, dynamic>{
      'id': 'act-${DateTime.now().microsecondsSinceEpoch}',
      'type': type.trim().isEmpty ? 'Accion' : type.trim(),
      'summary': summary.trim(),
      'owner': owner.trim().isEmpty ? 'Usuario' : owner.trim(),
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });

    return <String, dynamic>{'ok': true};
  }

  Map<String, dynamic> getAiInsights() {
    final riskyCount = _opportunities
        .where((item) => item['stage'] == OpportunityStage.requirement.code)
        .length;

    return <String, dynamic>{
      'items': <Map<String, dynamic>>[
        {
          'id': 'ins-001',
          'title': 'Prioriza seguimiento hoy',
          'detail':
              'Tienes $riskyCount oportunidad(es) en levantamiento sin avance en las ultimas 24h.',
          'priority': 'Alta',
        },
        {
          'id': 'ins-002',
          'title': 'Cross-sell recomendado',
          'detail':
              'En 2 cuentas puedes proponer conexiones y empaques junto con valvulas.',
          'priority': 'Media',
        },
      ],
    };
  }

  Map<String, dynamic> getAiRiskSummary() {
    var high = 0;
    var medium = 0;
    var low = 0;

    for (final item in _opportunities) {
      final probability = (item['probability'] as num?)?.toDouble() ?? 0;
      if (probability < 0.5) {
        high += 1;
      } else if (probability < 0.75) {
        medium += 1;
      } else {
        low += 1;
      }
    }

    return <String, dynamic>{'high': high, 'medium': medium, 'low': low};
  }

  Map<String, dynamic> getAiNextActions() {
    final items = <Map<String, dynamic>>[];

    for (final lead in _leads) {
      final amount = (lead['estimated_amount'] as num?)?.toDouble() ?? 0;
      final status = (lead['status'] as String?) ?? 'Nuevo';
      items.add(<String, dynamic>{
        'id': 'nba-${lead['id']}',
        'title': 'Atender lead ${lead['company_name']}',
        'reason':
            'Lead en estado $status con valor potencial ${_moneyCompact(amount)}.',
        'priority': _leadPriority(status, amount),
        'target_type': 'lead',
        'target_id': lead['id'] as String? ?? '',
        'suggested_task_title': 'Follow up lead ${lead['company_name']}',
        'suggested_task_type': 'Seguimiento',
        'suggested_due_date': lead['next_action_date'] as String? ?? '',
        '_score': _leadScore(status, amount),
      });
    }

    for (final opportunity in _opportunities) {
      final amount = (opportunity['amount'] as num?)?.toDouble() ?? 0;
      final probability = (opportunity['probability'] as num?)?.toDouble() ?? 0;
      items.add(<String, dynamic>{
        'id': 'nba-${opportunity['id']}',
        'title': 'Impulsar oportunidad ${opportunity['title']}',
        'reason':
            'Etapa ${(opportunity['stage'] as String?) ?? ''} con probabilidad ${(probability * 100).toStringAsFixed(0)}%.',
        'priority': _opportunityPriority(probability, amount),
        'target_type': 'opportunity',
        'target_id': opportunity['id'] as String? ?? '',
        'suggested_task_title': 'Empuje comercial ${opportunity['title']}',
        'suggested_task_type': 'Oportunidad',
        'suggested_due_date':
            opportunity['expected_close_date'] as String? ?? '',
        '_score': _opportunityScore(probability, amount),
      });
    }

    items.sort(
      (a, b) =>
          ((b['_score'] as num?) ?? 0).compareTo((a['_score'] as num?) ?? 0),
    );

    return <String, dynamic>{
      'items': items
          .take(5)
          .map((item) {
            final sanitized = Map<String, dynamic>.from(item);
            sanitized.remove('_score');
            return sanitized;
          })
          .toList(growable: false),
    };
  }

  Map<String, dynamic> generateFollowUpDraft({
    required String customerName,
    required String context,
    required String channel,
  }) {
    final greeting = channel.toLowerCase() == 'correo' ? 'Buen dia' : 'Hola';

    return <String, dynamic>{
      'draft':
          '$greeting $customerName, te comparto seguimiento de tu requerimiento: $context. '
          'Podemos confirmar existencias y tiempo de entrega hoy mismo. '
          'Si te parece, cierro la version final de cotizacion en cuanto me confirmes medidas.',
      'suggested_subject': 'Seguimiento cotizacion de tuberias y valvulas',
    };
  }

  double _leadScore(String status, double amount) {
    final base = switch (status.toLowerCase()) {
      'nuevo' => 82.0,
      'contactado' => 76.0,
      'calificado' => 88.0,
      _ => 70.0,
    };
    return base + (amount / 10000);
  }

  double _opportunityScore(double probability, double amount) {
    return (probability * 100) + (amount / 12000);
  }

  String _leadPriority(String status, double amount) {
    if (status.toLowerCase() == 'calificado' || amount >= 200000) {
      return 'Alta';
    }
    if (amount >= 80000) {
      return 'Media';
    }
    return 'Baja';
  }

  String _opportunityPriority(double probability, double amount) {
    if (probability >= 0.7 || amount >= 150000) {
      return 'Alta';
    }
    if (probability >= 0.5 || amount >= 70000) {
      return 'Media';
    }
    return 'Baja';
  }

  String _moneyCompact(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    }
    return '\$${(value / 1000).toStringAsFixed(0)}K';
  }
}
