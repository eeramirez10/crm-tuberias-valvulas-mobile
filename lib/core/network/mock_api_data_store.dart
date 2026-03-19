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

  Map<String, dynamic> getActivities() {
    return <String, dynamic>{'items': _activities};
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
}
