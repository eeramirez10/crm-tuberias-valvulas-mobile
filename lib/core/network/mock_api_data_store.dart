import 'dart:math';

import '../../features/opportunities/domain/entities/opportunity.dart';

class MockApiDataStore {
  MockApiDataStore._({
    required List<Map<String, dynamic>> customers,
    required List<Map<String, dynamic>> leads,
    required List<Map<String, dynamic>> products,
    required List<Map<String, dynamic>> opportunities,
    required List<Map<String, dynamic>> quotes,
    required List<Map<String, dynamic>> orders,
    required List<Map<String, dynamic>> tasks,
    required List<Map<String, dynamic>> activities,
  }) : _customers = customers,
       _leads = leads,
       _products = products,
       _opportunities = opportunities,
       _quotes = quotes,
       _orders = orders,
       _tasks = tasks,
       _activities = activities;

  factory MockApiDataStore.seeded() {
    return MockApiDataStore._(
      customers: <Map<String, dynamic>>[
        {
          'id': 'cus-001',
          'name': 'Constructora del Golfo',
          'segment': 'Construccion',
          'industrial_sector': 'Construccion',
          'contact_name': 'Carlos Mendez',
          'contact_phone': '+52 229 100 2001',
          'city': 'Veracruz',
          'project_state': 'Veracruz',
          'project_city': 'Veracruz',
          'project_latitude': 19.1738,
          'project_longitude': -96.1342,
          'credit_status': 'Aprobado',
        },
        {
          'id': 'cus-002',
          'name': 'Mantenimiento Industrial Norte',
          'segment': 'Industria',
          'industrial_sector': 'Energia',
          'contact_name': 'Laura Salinas',
          'contact_phone': '+52 818 500 3401',
          'city': 'Monterrey',
          'project_state': 'Nuevo Leon',
          'project_city': 'Monterrey',
          'project_latitude': 25.6866,
          'project_longitude': -100.3161,
          'credit_status': 'Revision',
        },
        {
          'id': 'cus-003',
          'name': 'Servicios Hidraulicos del Centro',
          'segment': 'Mantenimiento',
          'industrial_sector': 'Hidraulica',
          'contact_name': 'Diego Carranza',
          'contact_phone': '+52 222 150 7780',
          'city': 'Puebla',
          'project_state': 'Puebla',
          'project_city': 'Puebla',
          'project_latitude': 19.0414,
          'project_longitude': -98.2063,
          'credit_status': 'Aprobado',
        },
      ],
      leads: <Map<String, dynamic>>[
        {
          'id': 'lead-001',
          'company_name': 'Planta Embotelladora Delta',
          'contact_name': 'Rafael Ortega',
          'contact_phone': '+52 229 210 1145',
          'contact_email': 'rortega@delta.com.mx',
          'industrial_sector': 'Alimenticia',
          'credit_status': 'Activo',
          'project_state': 'Veracruz',
          'project_city': 'Veracruz',
          'project_latitude': 19.1738,
          'project_longitude': -96.1342,
          'required_delivery_time': '2-4 semanas',
          'main_competitor': 'Proveedor Local X',
          'material': 'Acero Inoxidable',
          'schedule': 'Sch 40',
          'nominal_diameter': '2"',
          'end_type': 'Bridado',
          'valve_type': 'Bola',
          'pressure_class': '300',
          'standard': 'ANSI',
          'loss_reason': '',
          'source': 'Referido',
          'status': 'Nuevo',
          'estimated_amount': 185000.0,
          'next_action_date': '2026-03-20',
          'owner': 'Erick Ramirez',
          'notes': 'Requiere valvulas de acero inoxidable para proceso CIP.',
        },
        {
          'id': 'lead-002',
          'company_name': 'Hotel Marina Azul',
          'contact_name': 'Karla Ruiz',
          'contact_phone': '+52 229 440 9930',
          'contact_email': 'compras@hotelmarinaazul.mx',
          'industrial_sector': 'Construccion',
          'credit_status': 'En Tramite',
          'project_state': 'Quintana Roo',
          'project_city': 'Cancun',
          'project_latitude': 21.1619,
          'project_longitude': -86.8515,
          'required_delivery_time': 'Inmediato',
          'main_competitor': 'Distribuidora del Caribe',
          'material': 'PVC',
          'schedule': 'Sch 80',
          'nominal_diameter': '4"',
          'end_type': 'Roscado',
          'valve_type': 'Compuerta',
          'pressure_class': '150',
          'standard': 'ASTM',
          'loss_reason': '',
          'source': 'Visita',
          'status': 'Contactado',
          'estimated_amount': 52000.0,
          'next_action_date': '2026-03-19',
          'owner': 'Erick Ramirez',
          'notes': 'Solicitan cotizacion para reemplazo de red hidraulica.',
        },
        {
          'id': 'lead-003',
          'company_name': 'Obra Periferico Sur Tramo 2',
          'contact_name': 'Fernando Cota',
          'contact_phone': '+52 667 390 2844',
          'contact_email': 'f.cota@constructoraipsa.com',
          'industrial_sector': 'Construccion',
          'credit_status': 'Suspendido',
          'project_state': 'Sinaloa',
          'project_city': 'Culiacan',
          'project_latitude': 24.8091,
          'project_longitude': -107.3940,
          'required_delivery_time': '4-6 semanas',
          'main_competitor': 'Aceros del Pacifico',
          'material': 'Acero al Carbon',
          'schedule': 'Sch 80',
          'nominal_diameter': '8"',
          'end_type': 'Biselado',
          'valve_type': 'Check',
          'pressure_class': '600',
          'standard': 'API',
          'loss_reason': '',
          'source': 'Llamada',
          'status': 'Calificado',
          'estimated_amount': 430000.0,
          'next_action_date': '2026-03-22',
          'owner': 'Mariana Solis',
          'notes': 'Proyecto con entrega parcial por frentes de obra.',
        },
      ],
      products: <Map<String, dynamic>>[
        {
          'id': 'prd-001',
          'sku': 'TUB-C40-4M',
          'name': 'Tuberia acero cedula 40 4"',
          'category': 'Tuberia',
          'unit': 'tramo 6m',
          'stock': 120,
          'list_price': 7800.0,
          'min_price': 7000.0,
          'unit_cost': 5600.0,
        },
        {
          'id': 'prd-002',
          'sku': 'VAL-COM-2',
          'name': 'Valvula compuerta acero 2"',
          'category': 'Valvula',
          'unit': 'pieza',
          'stock': 77,
          'list_price': 9400.0,
          'min_price': 8600.0,
          'unit_cost': 6800.0,
        },
        {
          'id': 'prd-003',
          'sku': 'CON-BRI-4',
          'name': 'Brida ASTM A105 4"',
          'category': 'Conexion',
          'unit': 'pieza',
          'stock': 190,
          'list_price': 780.0,
          'min_price': 700.0,
          'unit_cost': 500.0,
        },
        {
          'id': 'prd-004',
          'sku': 'EMP-NBR-4',
          'name': 'Empaque NBR 4"',
          'category': 'Accesorio',
          'unit': 'pieza',
          'stock': 300,
          'list_price': 120.0,
          'min_price': 100.0,
          'unit_cost': 60.0,
        },
        {
          'id': 'prd-005',
          'sku': 'TUB-GAL-2',
          'name': 'Tuberia galvanizada 2"',
          'category': 'Tuberia',
          'unit': 'tramo 6m',
          'stock': 95,
          'list_price': 4200.0,
          'min_price': 3800.0,
          'unit_cost': 2950.0,
        },
        {
          'id': 'prd-006',
          'sku': 'VAL-BOL-3',
          'name': 'Valvula de bola inox 3"',
          'category': 'Valvula',
          'unit': 'pieza',
          'stock': 38,
          'list_price': 12800.0,
          'min_price': 11500.0,
          'unit_cost': 9300.0,
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
          'last_movement_date': '2026-04-02',
          'industrial_sector': 'Construccion',
          'project_state': 'Veracruz',
          'project_city': 'Veracruz',
          'required_delivery_time': '2-4 semanas',
          'main_competitor': 'Proveedor Local X',
          'material': 'Acero al Carbon',
          'schedule': 'Sch 40',
          'nominal_diameter': '4"',
          'end_type': 'Bridado',
          'valve_type': 'Compuerta',
          'pressure_class': '300',
          'standard': 'ANSI',
          'loss_reason': '',
        },
        {
          'id': 'opp-002',
          'customer_name': 'Mantenimiento Industrial Norte',
          'title': 'Valvula compuerta acero 2 pulgadas',
          'stage': OpportunityStage.negotiation.code,
          'amount': 94000.0,
          'probability': 0.75,
          'expected_close_date': '2026-03-25',
          'last_movement_date': '2026-04-08',
          'industrial_sector': 'Energia',
          'project_state': 'Nuevo Leon',
          'project_city': 'Monterrey',
          'required_delivery_time': 'Inmediato',
          'main_competitor': 'Distribuidora del Norte',
          'material': 'Acero al Carbon',
          'schedule': 'Sch 80',
          'nominal_diameter': '2"',
          'end_type': 'Roscado',
          'valve_type': 'Compuerta',
          'pressure_class': '150',
          'standard': 'API',
          'loss_reason': '',
        },
        {
          'id': 'opp-003',
          'customer_name': 'Servicios Hidraulicos del Centro',
          'title': 'Paquete conexiones galvanizadas',
          'stage': OpportunityStage.requirement.code,
          'amount': 48000.0,
          'probability': 0.4,
          'expected_close_date': '2026-04-05',
          'last_movement_date': '2026-04-09',
          'industrial_sector': 'Hidraulica',
          'project_state': 'Puebla',
          'project_city': 'Puebla',
          'required_delivery_time': '2-4 semanas',
          'main_competitor': 'Aceros Puebla',
          'material': 'Galvanizado',
          'schedule': 'Sch 40',
          'nominal_diameter': '3"',
          'end_type': 'Roscado',
          'valve_type': 'Check',
          'pressure_class': '300',
          'standard': 'ASTM',
          'loss_reason': '',
        },
        {
          'id': 'opp-004',
          'customer_name': 'Proyecto Bombeo Sierra',
          'title': 'Suministro valvulas check 6 pulgadas',
          'stage': OpportunityStage.lost.code,
          'amount': 165000.0,
          'probability': 0.1,
          'expected_close_date': '2026-03-18',
          'last_movement_date': '2026-03-18',
          'industrial_sector': 'Mineria',
          'project_state': 'Sonora',
          'project_city': 'Hermosillo',
          'required_delivery_time': 'Inmediato',
          'main_competitor': 'Aceros del Pacifico',
          'material': 'Acero al Carbon',
          'schedule': 'Sch 80',
          'nominal_diameter': '6"',
          'end_type': 'Bridado',
          'valve_type': 'Check',
          'pressure_class': '600',
          'standard': 'API',
          'loss_reason': 'Precio',
        },
        {
          'id': 'opp-005',
          'customer_name': 'Petroquimica del Centro',
          'title': 'Linea de valvulas de aislamiento',
          'stage': OpportunityStage.lost.code,
          'amount': 280000.0,
          'probability': 0.1,
          'expected_close_date': '2026-03-15',
          'last_movement_date': '2026-03-15',
          'industrial_sector': 'Gas y Petroleo',
          'project_state': 'Tamaulipas',
          'project_city': 'Altamira',
          'required_delivery_time': '2-4 semanas',
          'main_competitor': 'Importador directo',
          'material': 'Inoxidable',
          'schedule': 'Sch 40',
          'nominal_diameter': '8"',
          'end_type': 'Bridado',
          'valve_type': 'Compuerta',
          'pressure_class': '300',
          'standard': 'ANSI',
          'loss_reason': 'Tiempo de entrega',
        },
        {
          'id': 'opp-006',
          'customer_name': 'Acueducto Occidente',
          'title': 'Proyecto renovacion red de valvulas',
          'stage': OpportunityStage.won.code,
          'amount': 198000.0,
          'probability': 0.95,
          'expected_close_date': '2026-04-12',
          'last_movement_date': '2026-04-09',
          'industrial_sector': 'Hidraulica',
          'project_state': 'Jalisco',
          'project_city': 'Guadalajara',
          'required_delivery_time': '2-4 semanas',
          'main_competitor': 'Distribuidora del Norte',
          'material': 'Acero al Carbon',
          'schedule': 'Sch 40',
          'nominal_diameter': '10"',
          'end_type': 'Bridado',
          'valve_type': 'Compuerta',
          'pressure_class': '300',
          'standard': 'ANSI',
          'loss_reason': '',
        },
      ],
      quotes: <Map<String, dynamic>>[
        {
          'id': 'quo-001',
          'code': 'COT-2026-001',
          'customer_name': 'Constructora del Golfo',
          'related_type': 'opportunity',
          'related_id': 'opp-001',
          'status': 'Enviada',
          'items_count': 3,
          'subtotal': 184000.0,
          'discount': 4560.0,
          'tax': 28710.4,
          'total': 208150.4,
          'valid_until': '2026-03-30',
          'created_at': '2026-03-18',
          'margin_rate': 0.2655,
          'lines': <Map<String, dynamic>>[
            {
              'product_id': 'prd-001',
              'product_sku': 'TUB-C40-4M',
              'product_name': 'Tuberia acero cedula 40 4"',
              'product_category': 'Tuberia',
              'unit': 'tramo 6m',
              'quantity': 20,
              'unit_price': 7600.0,
              'min_unit_price': 7000.0,
              'unit_cost': 5600.0,
              'stock_available': 120,
              'line_subtotal': 152000.0,
              'line_discount': 4560.0,
              'line_total': 147440.0,
              'margin_rate': 0.2404,
            },
            {
              'product_id': 'prd-003',
              'product_sku': 'CON-BRI-4',
              'product_name': 'Brida ASTM A105 4"',
              'product_category': 'Conexion',
              'unit': 'pieza',
              'quantity': 30,
              'unit_price': 760.0,
              'min_unit_price': 700.0,
              'unit_cost': 500.0,
              'stock_available': 210,
              'line_subtotal': 22800.0,
              'line_discount': 0.0,
              'line_total': 22800.0,
              'margin_rate': 0.3421,
            },
            {
              'product_id': 'prd-004',
              'product_sku': 'EMP-NBR-4',
              'product_name': 'Empaque NBR 4"',
              'product_category': 'Accesorio',
              'unit': 'pieza',
              'quantity': 80,
              'unit_price': 115.0,
              'min_unit_price': 100.0,
              'unit_cost': 60.0,
              'stock_available': 300,
              'line_subtotal': 9200.0,
              'line_discount': 0.0,
              'line_total': 9200.0,
              'margin_rate': 0.4783,
            },
          ],
        },
        {
          'id': 'quo-002',
          'code': 'COT-2026-002',
          'customer_name': 'Mantenimiento Industrial Norte',
          'related_type': 'opportunity',
          'related_id': 'opp-002',
          'status': 'Convertida',
          'order_id': 'ord-001',
          'items_count': 2,
          'subtotal': 89000.0,
          'discount': 1880.0,
          'tax': 13939.2,
          'total': 101059.2,
          'valid_until': '2026-03-27',
          'created_at': '2026-03-17',
          'margin_rate': 0.2644,
          'lines': <Map<String, dynamic>>[
            {
              'product_id': 'prd-002',
              'product_sku': 'VAL-COM-2',
              'product_name': 'Valvula compuerta acero 2"',
              'product_category': 'Valvula',
              'unit': 'pieza',
              'quantity': 8,
              'unit_price': 9200.0,
              'min_unit_price': 8600.0,
              'unit_cost': 6800.0,
              'stock_available': 85,
              'line_subtotal': 73600.0,
              'line_discount': 0.0,
              'line_total': 73600.0,
              'margin_rate': 0.2609,
            },
            {
              'product_id': 'prd-003',
              'product_sku': 'CON-BRI-4',
              'product_name': 'Brida ASTM A105 4"',
              'product_category': 'Conexion',
              'unit': 'pieza',
              'quantity': 20,
              'unit_price': 770.0,
              'min_unit_price': 700.0,
              'unit_cost': 500.0,
              'stock_available': 210,
              'line_subtotal': 15400.0,
              'line_discount': 1880.0,
              'line_total': 13520.0,
              'margin_rate': 0.2604,
            },
          ],
        },
        {
          'id': 'quo-003',
          'code': 'COT-2026-003',
          'customer_name': 'Planta Embotelladora Delta',
          'related_type': 'lead',
          'related_id': 'lead-001',
          'status': 'Borrador',
          'items_count': 2,
          'subtotal': 69600.0,
          'discount': 0.0,
          'tax': 11136.0,
          'total': 80736.0,
          'valid_until': '2026-03-31',
          'created_at': '2026-03-19',
          'margin_rate': 0.2862,
          'lines': <Map<String, dynamic>>[
            {
              'product_id': 'prd-005',
              'product_sku': 'TUB-GAL-2',
              'product_name': 'Tuberia galvanizada 2"',
              'product_category': 'Tuberia',
              'unit': 'tramo 6m',
              'quantity': 12,
              'unit_price': 4100.0,
              'min_unit_price': 3800.0,
              'unit_cost': 2950.0,
              'stock_available': 95,
              'line_subtotal': 49200.0,
              'line_discount': 0.0,
              'line_total': 49200.0,
              'margin_rate': 0.1366,
            },
            {
              'product_id': 'prd-006',
              'product_sku': 'VAL-BOL-3',
              'product_name': 'Valvula de bola inox 3"',
              'product_category': 'Valvula',
              'unit': 'pieza',
              'quantity': 2,
              'unit_price': 10200.0,
              'min_unit_price': 11500.0,
              'unit_cost': 9300.0,
              'stock_available': 38,
              'line_subtotal': 20400.0,
              'line_discount': 0.0,
              'line_total': 20400.0,
              'margin_rate': 0.0882,
            },
          ],
        },
      ],
      orders: <Map<String, dynamic>>[
        {
          'id': 'ord-001',
          'code': 'PED-2026-001',
          'quote_id': 'quo-002',
          'quote_code': 'COT-2026-002',
          'customer_name': 'Mantenimiento Industrial Norte',
          'status': 'Enviado',
          'total': 101059.2,
          'created_at': '2026-03-18',
          'promised_date': '2026-03-24',
          'shipped_at': '2026-03-22',
          'delivered_at': null,
          'inventory_reserved': true,
          'lines': <Map<String, dynamic>>[
            {
              'product_id': 'prd-002',
              'product_sku': 'VAL-COM-2',
              'product_name': 'Valvula compuerta acero 2"',
              'product_category': 'Valvula',
              'unit': 'pieza',
              'quantity': 8,
              'unit_price': 9200.0,
              'line_total': 73600.0,
              'stock_available': 77,
            },
            {
              'product_id': 'prd-003',
              'product_sku': 'CON-BRI-4',
              'product_name': 'Brida ASTM A105 4"',
              'product_category': 'Conexion',
              'unit': 'pieza',
              'quantity': 20,
              'unit_price': 770.0,
              'line_total': 13520.0,
              'stock_available': 190,
            },
          ],
        },
      ],
      tasks: <Map<String, dynamic>>[],
      activities: <Map<String, dynamic>>[],
    );
  }

  final List<Map<String, dynamic>> _customers;
  final List<Map<String, dynamic>> _leads;
  final List<Map<String, dynamic>> _products;
  final List<Map<String, dynamic>> _opportunities;
  final List<Map<String, dynamic>> _quotes;
  final List<Map<String, dynamic>> _orders;
  final List<Map<String, dynamic>> _tasks;
  final List<Map<String, dynamic>> _activities;

  Map<String, dynamic> getDashboardSummary() {
    final activeOpportunities = _opportunities
        .where((item) {
          final stage = (item['stage'] as String? ?? '').trim();
          return stage != OpportunityStage.won.code &&
              stage != OpportunityStage.lost.code;
        })
        .toList(growable: false);
    final pipelineValue = activeOpportunities.fold<double>(
      0,
      (sum, item) => sum + ((item['amount'] as num?)?.toDouble() ?? 0),
    );

    final openTasks = _tasks
        .where((task) => task['completed'] as bool == false)
        .length;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monthQuotes = _quotes
        .where((quote) {
          final createdRaw = quote['created_at'] as String? ?? '';
          final createdAt = DateTime.tryParse(createdRaw);
          if (createdAt == null) {
            return false;
          }
          return createdAt.year == now.year && createdAt.month == now.month;
        })
        .toList(growable: false);
    final quotesThisMonth = monthQuotes.length;

    final approvedQuotes = _quotes
        .where(
          (quote) =>
              quote['status'] == 'Aprobada' || quote['status'] == 'Convertida',
        )
        .toList(growable: false);
    final approvedAmount = approvedQuotes.fold<double>(
      0,
      (sum, quote) => sum + ((quote['total'] as num?)?.toDouble() ?? 0),
    );
    final approvalRate = _quotes.isEmpty
        ? 0.0
        : approvedQuotes.length / _quotes.length;
    final byProduct = <String, ({String name, int quantity})>{};
    for (final quote in monthQuotes) {
      final lines = (quote['lines'] as List<dynamic>? ?? <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .toList(growable: false);
      for (final line in lines) {
        final productId = line['product_id'] as String? ?? '';
        final productName = line['product_name'] as String? ?? 'Producto';
        final quantity = (line['quantity'] as num?)?.toInt() ?? 0;
        final current = byProduct[productId];
        byProduct[productId] = current == null
            ? (name: productName, quantity: quantity)
            : (name: current.name, quantity: current.quantity + quantity);
      }
    }

    final topProducts = byProduct.entries.toList(growable: false)
      ..sort((a, b) => b.value.quantity.compareTo(a.value.quantity));
    final monthOrders = _orders
        .where((order) {
          final created = DateTime.tryParse(
            order['created_at'] as String? ?? '',
          );
          if (created == null) {
            return false;
          }
          return created.year == now.year && created.month == now.month;
        })
        .toList(growable: false);
    final deliveredOrders = _orders
        .where((order) => order['status'] == 'Entregado')
        .toList(growable: false);
    final deliveredOnTime = deliveredOrders.where((order) {
      final promised = DateTime.tryParse(
        order['promised_date'] as String? ?? '',
      );
      final delivered = DateTime.tryParse(
        order['delivered_at'] as String? ?? '',
      );
      if (promised == null || delivered == null) {
        return false;
      }
      return delivered.isBefore(promised.add(const Duration(days: 1)));
    }).length;
    final onTimeRate = deliveredOrders.isEmpty
        ? 0.0
        : deliveredOnTime / deliveredOrders.length;
    final ordersBacklog = _orders
        .where(
          (order) =>
              order['status'] == 'Nuevo' || order['status'] == 'En surtido',
        )
        .length;
    final wonDeals = _opportunities
        .where((item) => item['stage'] == OpportunityStage.won.code)
        .toList(growable: false);
    final wonThisMonth = wonDeals.fold<double>(0, (sum, item) {
      final movement = DateTime.tryParse(
        item['last_movement_date'] as String? ?? '',
      );
      if (movement == null ||
          movement.year != now.year ||
          movement.month != now.month) {
        return sum;
      }
      return sum + ((item['amount'] as num?)?.toDouble() ?? 0);
    });
    final closedDeals = _opportunities
        .where(
          (item) =>
              item['stage'] == OpportunityStage.won.code ||
              item['stage'] == OpportunityStage.lost.code,
        )
        .toList(growable: false);
    final conversionRate = closedDeals.isEmpty
        ? 0.0
        : wonDeals.length / closedDeals.length;

    final inactiveHighValueQuotes = activeOpportunities
        .where((item) {
          final stage = item['stage'] as String? ?? '';
          final inQuoteStage =
              stage == OpportunityStage.quotation.code ||
              stage == OpportunityStage.negotiation.code;
          if (!inQuoteStage) {
            return false;
          }
          final amount = (item['amount'] as num?)?.toDouble() ?? 0;
          if (amount < 100000) {
            return false;
          }
          final movement = DateTime.tryParse(
            item['last_movement_date'] as String? ?? '',
          );
          if (movement == null) {
            return false;
          }
          final movementDate = DateTime(
            movement.year,
            movement.month,
            movement.day,
          );
          final inactiveDays = today.difference(movementDate).inDays;
          return inactiveDays >= 5;
        })
        .toList(growable: false);
    final inactiveHighValueAmount = inactiveHighValueQuotes.fold<double>(
      0,
      (sum, item) => sum + ((item['amount'] as num?)?.toDouble() ?? 0),
    );

    final lostDeals = _opportunities
        .where((item) => item['stage'] == OpportunityStage.lost.code)
        .toList(growable: false);
    var lostByPrice = 0;
    var lostByStock = 0;
    var lostByDelivery = 0;
    var lostByTechnical = 0;
    for (final item in lostDeals) {
      final reason = (item['loss_reason'] as String? ?? '').toLowerCase();
      if (reason.contains('precio')) {
        lostByPrice += 1;
      } else if (reason.contains('stock') || reason.contains('inventario')) {
        lostByStock += 1;
      } else if (reason.contains('entrega') || reason.contains('tiempo')) {
        lostByDelivery += 1;
      } else {
        lostByTechnical += 1;
      }
    }

    return <String, dynamic>{
      'total_customers': _customers.length,
      'active_leads': _leads.length,
      'pipeline_value': pipelineValue,
      'open_tasks': openTasks,
      'won_this_month': wonThisMonth,
      'conversion_rate': conversionRate,
      'quotes_this_month': quotesThisMonth,
      'quotes_approval_rate': approvalRate,
      'quotes_approved_amount': approvedAmount,
      'orders_this_month': monthOrders.length,
      'orders_on_time_rate': onTimeRate,
      'orders_backlog': ordersBacklog,
      'high_value_inactive_quotes_count': inactiveHighValueQuotes.length,
      'high_value_inactive_quotes_amount': inactiveHighValueAmount,
      'lost_deals_total': lostDeals.length,
      'lost_deals_by_price': lostByPrice,
      'lost_deals_by_stock': lostByStock,
      'lost_deals_by_delivery': lostByDelivery,
      'lost_deals_by_technical': lostByTechnical,
      'top_quoted_products': topProducts
          .take(3)
          .map(
            (entry) => <String, dynamic>{
              'product_name': entry.value.name,
              'quantity': entry.value.quantity,
            },
          )
          .toList(growable: false),
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

  Map<String, dynamic> getProducts({String? query, String? category}) {
    var filtered = _products;

    if (query != null && query.trim().isNotEmpty) {
      final normalized = query.toLowerCase().trim();
      filtered = filtered
          .where(
            (item) =>
                (item['name'] as String).toLowerCase().contains(normalized) ||
                (item['sku'] as String).toLowerCase().contains(normalized),
          )
          .toList(growable: false);
    }

    if (category != null && category.trim().isNotEmpty) {
      filtered = filtered
          .where(
            (item) =>
                (item['category'] as String).toLowerCase() ==
                category.toLowerCase(),
          )
          .toList(growable: false);
    }

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

  Map<String, dynamic> createLead({
    required String companyName,
    required String contactName,
    required String contactPhone,
    required String contactEmail,
    required String industrialSector,
    required String creditStatus,
    required String projectState,
    required String projectCity,
    required double? projectLatitude,
    required double? projectLongitude,
    required String requiredDeliveryTime,
    required String mainCompetitor,
    required String material,
    required String schedule,
    required String nominalDiameter,
    required String endType,
    required String valveType,
    required String pressureClass,
    required String standard,
    required String lossReason,
    required String source,
    required String status,
    required double estimatedAmount,
    required String nextActionDate,
    required String owner,
    required String notes,
  }) {
    if (companyName.trim().isEmpty ||
        contactName.trim().isEmpty ||
        owner.trim().isEmpty) {
      return <String, dynamic>{
        'ok': false,
        'message': 'Empresa, contacto y responsable son obligatorios.',
        'item': <String, dynamic>{},
      };
    }

    final normalizedStatus = status.trim().isEmpty ? 'Nuevo' : status.trim();
    final id = 'lead-${DateTime.now().microsecondsSinceEpoch}';
    final item = <String, dynamic>{
      'id': id,
      'company_name': companyName.trim(),
      'contact_name': contactName.trim(),
      'contact_phone': contactPhone.trim(),
      'contact_email': contactEmail.trim(),
      'industrial_sector': industrialSector.trim(),
      'credit_status': creditStatus.trim(),
      'project_state': projectState.trim(),
      'project_city': projectCity.trim(),
      'project_latitude': projectLatitude,
      'project_longitude': projectLongitude,
      'required_delivery_time': requiredDeliveryTime.trim(),
      'main_competitor': mainCompetitor.trim(),
      'material': material.trim(),
      'schedule': schedule.trim(),
      'nominal_diameter': nominalDiameter.trim(),
      'end_type': endType.trim(),
      'valve_type': valveType.trim(),
      'pressure_class': pressureClass.trim(),
      'standard': standard.trim(),
      'loss_reason': lossReason.trim(),
      'source': source.trim().isEmpty ? 'Formulario' : source.trim(),
      'status': normalizedStatus,
      'estimated_amount': max(0, estimatedAmount),
      'next_action_date': nextActionDate.trim().isEmpty
          ? DateTime.now()
                .add(const Duration(days: 2))
                .toIso8601String()
                .split('T')
                .first
          : nextActionDate.trim(),
      'owner': owner.trim(),
      'notes': notes.trim(),
    };

    _leads.insert(0, item);
    _activities.insert(0, <String, dynamic>{
      'id': 'act-${DateTime.now().millisecondsSinceEpoch}',
      'type': 'Prospecto',
      'summary': 'Nuevo prospecto registrado: ${companyName.trim()}.',
      'owner': owner.trim(),
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });

    return <String, dynamic>{'ok': true, 'item': item};
  }

  Map<String, dynamic> updateLead({
    required String leadId,
    required String companyName,
    required String contactName,
    required String contactPhone,
    required String contactEmail,
    required String industrialSector,
    required String creditStatus,
    required String projectState,
    required String projectCity,
    required double? projectLatitude,
    required double? projectLongitude,
    required String requiredDeliveryTime,
    required String mainCompetitor,
    required String material,
    required String schedule,
    required String nominalDiameter,
    required String endType,
    required String valveType,
    required String pressureClass,
    required String standard,
    required String lossReason,
    required String source,
    required String status,
    required double estimatedAmount,
    required String nextActionDate,
    required String owner,
    required String notes,
  }) {
    final index = _leads.indexWhere((lead) => lead['id'] == leadId);
    if (index == -1) {
      return <String, dynamic>{
        'ok': false,
        'message': 'Prospecto no encontrado.',
        'item': <String, dynamic>{},
      };
    }

    if (companyName.trim().isEmpty ||
        contactName.trim().isEmpty ||
        owner.trim().isEmpty) {
      return <String, dynamic>{
        'ok': false,
        'message': 'Empresa, contacto y responsable son obligatorios.',
        'item': <String, dynamic>{},
      };
    }

    final current = _leads[index];
    final currentStatus = current['status'] as String? ?? 'Nuevo';
    final normalizedStatus = status.trim().isEmpty
        ? currentStatus
        : status.trim();

    final updated = <String, dynamic>{
      ...current,
      'company_name': companyName.trim(),
      'contact_name': contactName.trim(),
      'contact_phone': contactPhone.trim(),
      'contact_email': contactEmail.trim(),
      'industrial_sector': industrialSector.trim(),
      'credit_status': creditStatus.trim(),
      'project_state': projectState.trim(),
      'project_city': projectCity.trim(),
      'project_latitude': projectLatitude,
      'project_longitude': projectLongitude,
      'required_delivery_time': requiredDeliveryTime.trim(),
      'main_competitor': mainCompetitor.trim(),
      'material': material.trim(),
      'schedule': schedule.trim(),
      'nominal_diameter': nominalDiameter.trim(),
      'end_type': endType.trim(),
      'valve_type': valveType.trim(),
      'pressure_class': pressureClass.trim(),
      'standard': standard.trim(),
      'loss_reason': lossReason.trim(),
      'source': source.trim().isEmpty ? 'Formulario' : source.trim(),
      'status': normalizedStatus,
      'estimated_amount': max(0, estimatedAmount),
      'next_action_date': nextActionDate.trim().isEmpty
          ? current['next_action_date']
          : nextActionDate.trim(),
      'owner': owner.trim(),
      'notes': notes.trim(),
    };
    _leads[index] = updated;

    _activities.insert(0, <String, dynamic>{
      'id': 'act-${DateTime.now().millisecondsSinceEpoch}',
      'type': 'Prospecto',
      'summary': normalizedStatus != currentStatus
          ? 'Prospecto ${companyName.trim()} movido de $currentStatus a $normalizedStatus.'
          : 'Prospecto actualizado: ${companyName.trim()}.',
      'owner': owner.trim(),
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });

    return <String, dynamic>{'ok': true, 'item': updated};
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

  Map<String, dynamic> createOpportunity({
    required String customerName,
    required String title,
    required String stage,
    required double amount,
    required double probability,
    required String expectedCloseDate,
    required String industrialSector,
    required String projectState,
    required String projectCity,
    required String requiredDeliveryTime,
    required String mainCompetitor,
    required String material,
    required String schedule,
    required String nominalDiameter,
    required String endType,
    required String valveType,
    required String pressureClass,
    required String standard,
    required String lossReason,
  }) {
    if (customerName.trim().isEmpty || title.trim().isEmpty) {
      return <String, dynamic>{
        'ok': false,
        'message': 'Cliente y titulo son obligatorios.',
        'item': <String, dynamic>{},
      };
    }
    if (amount <= 0) {
      return <String, dynamic>{
        'ok': false,
        'message': 'El monto debe ser mayor a cero.',
        'item': <String, dynamic>{},
      };
    }

    final normalizedStage = stage.trim().isEmpty
        ? OpportunityStage.requirement.code
        : stage.trim();
    final stageEntity = OpportunityStageX.fromCode(normalizedStage);
    final normalizedProbability = probability <= 0
        ? _defaultProbabilityByStage(stageEntity)
        : probability.clamp(0.05, 0.95);
    final normalizedDate = expectedCloseDate.trim().isEmpty
        ? DateTime.now()
              .add(const Duration(days: 14))
              .toIso8601String()
              .split('T')
              .first
        : expectedCloseDate.trim();

    final item = <String, dynamic>{
      'id': 'opp-${DateTime.now().microsecondsSinceEpoch}',
      'customer_name': customerName.trim(),
      'title': title.trim(),
      'stage': stageEntity.code,
      'amount': amount,
      'probability': normalizedProbability,
      'expected_close_date': normalizedDate,
      'last_movement_date': DateTime.now().toIso8601String().split('T').first,
      'industrial_sector': industrialSector.trim(),
      'project_state': projectState.trim(),
      'project_city': projectCity.trim(),
      'required_delivery_time': requiredDeliveryTime.trim(),
      'main_competitor': mainCompetitor.trim(),
      'material': material.trim(),
      'schedule': schedule.trim(),
      'nominal_diameter': nominalDiameter.trim(),
      'end_type': endType.trim(),
      'valve_type': valveType.trim(),
      'pressure_class': pressureClass.trim(),
      'standard': standard.trim(),
      'loss_reason': lossReason.trim(),
    };
    _opportunities.insert(0, item);

    _activities.insert(0, <String, dynamic>{
      'id': 'act-${DateTime.now().millisecondsSinceEpoch}',
      'type': 'Deal',
      'summary': 'Nuevo deal creado: ${title.trim()} (${customerName.trim()}).',
      'owner': 'Erick Ramirez',
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });

    return <String, dynamic>{'ok': true, 'item': item};
  }

  Map<String, dynamic> getQuotes({String? status}) {
    if (status == null || status.trim().isEmpty) {
      return <String, dynamic>{'items': _quotes};
    }

    final filtered = _quotes
        .where((item) => (item['status'] as String?) == status)
        .toList(growable: false);
    return <String, dynamic>{'items': filtered};
  }

  Map<String, dynamic> getQuoteById(String id) {
    final index = _quotes.indexWhere((quote) => quote['id'] == id);
    if (index == -1) {
      return <String, dynamic>{'item': <String, dynamic>{}};
    }
    return <String, dynamic>{'item': _quotes[index]};
  }

  Map<String, dynamic> getOrders({String? status}) {
    if (status == null || status.trim().isEmpty) {
      return <String, dynamic>{'items': _orders};
    }

    final filtered = _orders
        .where((item) => (item['status'] as String?) == status)
        .toList(growable: false);
    return <String, dynamic>{'items': filtered};
  }

  Map<String, dynamic> getOrderById(String id) {
    final index = _orders.indexWhere((order) => order['id'] == id);
    if (index == -1) {
      return <String, dynamic>{'item': <String, dynamic>{}};
    }
    return <String, dynamic>{'item': _orders[index]};
  }

  Map<String, dynamic> createQuote({
    required String customerName,
    required String relatedType,
    required String relatedId,
    required List<Map<String, dynamic>> lines,
    required double taxRate,
    required String validUntil,
  }) {
    if (customerName.trim().isEmpty ||
        relatedId.trim().isEmpty ||
        lines.isEmpty) {
      return <String, dynamic>{
        'ok': false,
        'message': 'Cliente, relacionado y lineas son obligatorios.',
        'item': <String, dynamic>{},
      };
    }

    final normalizedLines = <Map<String, dynamic>>[];
    var subtotal = 0.0;
    var discount = 0.0;
    var marginRevenue = 0.0;
    var marginCost = 0.0;
    for (final line in lines) {
      final productId = line['product_id'] as String? ?? '';
      final quantity = (line['quantity'] as num?)?.toInt() ?? 0;
      final unitPrice = (line['unit_price'] as num?)?.toDouble() ?? 0;
      final discountRate = ((line['discount_rate'] as num?)?.toDouble() ?? 0)
          .clamp(0.0, 0.8);
      final productIndex = _products.indexWhere(
        (item) => item['id'] == productId,
      );
      final product = productIndex == -1 ? null : _products[productIndex];

      if (product == null) {
        return <String, dynamic>{
          'ok': false,
          'message': 'Producto no encontrado en catalogo.',
          'item': <String, dynamic>{},
        };
      }

      if (quantity <= 0) {
        return <String, dynamic>{
          'ok': false,
          'message': 'La cantidad debe ser mayor a cero.',
          'item': <String, dynamic>{},
        };
      }

      final stock = (product['stock'] as num?)?.toInt() ?? 0;
      final minPrice = (product['min_price'] as num?)?.toDouble() ?? 0;
      final unitCost = (product['unit_cost'] as num?)?.toDouble() ?? 0;
      if (quantity > stock) {
        return <String, dynamic>{
          'ok': false,
          'message': 'Stock insuficiente para ${product['name']}.',
          'item': <String, dynamic>{},
        };
      }
      if (unitPrice < minPrice) {
        return <String, dynamic>{
          'ok': false,
          'message':
              'Precio debajo del minimo para ${product['name']} (${_moneyCompact(minPrice)}).',
          'item': <String, dynamic>{},
        };
      }

      final lineSubtotal = quantity * unitPrice;
      final lineDiscount = lineSubtotal * discountRate;
      final lineTotal = lineSubtotal - lineDiscount;
      final lineCost = quantity * unitCost;
      final marginRate = lineTotal <= 0
          ? 0.0
          : (lineTotal - lineCost) / lineTotal;

      normalizedLines.add(<String, dynamic>{
        'product_id': product['id'],
        'product_sku': product['sku'],
        'product_name': product['name'],
        'product_category': product['category'],
        'unit': product['unit'],
        'quantity': quantity,
        'unit_price': unitPrice,
        'min_unit_price': minPrice,
        'unit_cost': unitCost,
        'stock_available': stock,
        'line_subtotal': lineSubtotal,
        'line_discount': lineDiscount,
        'line_total': lineTotal,
        'margin_rate': marginRate,
      });
      subtotal += lineSubtotal;
      discount += lineDiscount;
      marginRevenue += lineTotal;
      marginCost += lineCost;
    }

    final taxableBase = max(0.0, subtotal - discount);
    final tax = taxableBase * taxRate.clamp(0.0, 0.35);
    final total = taxableBase + tax;
    final marginRate = marginRevenue <= 0
        ? 0.0
        : (marginRevenue - marginCost) / marginRevenue;
    final quoteNumber = _quotes.length + 1;
    final id = 'quo-${DateTime.now().microsecondsSinceEpoch}';
    final item = <String, dynamic>{
      'id': id,
      'code': 'COT-2026-${quoteNumber.toString().padLeft(3, '0')}',
      'customer_name': customerName.trim(),
      'related_type': relatedType.trim().isEmpty ? 'lead' : relatedType.trim(),
      'related_id': relatedId.trim(),
      'status': 'Borrador',
      'items_count': normalizedLines.length,
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'total': max(0, total),
      'valid_until': validUntil.trim().isEmpty
          ? '2026-03-30'
          : validUntil.trim(),
      'created_at': DateTime.now().toIso8601String().split('T').first,
      'margin_rate': marginRate,
      'lines': normalizedLines,
    };

    _quotes.insert(0, item);
    return <String, dynamic>{'ok': true, 'item': item};
  }

  Map<String, dynamic> updateQuoteStatus({
    required String id,
    required String status,
  }) {
    final index = _quotes.indexWhere((quote) => quote['id'] == id);
    if (index == -1) {
      return <String, dynamic>{
        'ok': false,
        'message': 'Cotizacion no encontrada.',
      };
    }

    _quotes[index] = <String, dynamic>{
      ..._quotes[index],
      'status': status.trim().isEmpty ? 'Borrador' : status.trim(),
    };

    return <String, dynamic>{'ok': true};
  }

  Map<String, dynamic> convertQuoteToOrder(String id) {
    final quoteIndex = _quotes.indexWhere((quote) => quote['id'] == id);
    if (quoteIndex == -1) {
      return <String, dynamic>{
        'ok': false,
        'message': 'Cotizacion no encontrada.',
      };
    }

    final quote = _quotes[quoteIndex];
    if (quote['status'] == 'Rechazada') {
      return <String, dynamic>{
        'ok': false,
        'message': 'No se puede convertir una cotizacion rechazada.',
      };
    }

    final existingOrderId = quote['order_id'] as String?;
    if (existingOrderId != null && existingOrderId.isNotEmpty) {
      return <String, dynamic>{'ok': true, 'order_id': existingOrderId};
    }

    final orderNumber = _orders.length + 1;
    final orderId = 'ord-${DateTime.now().microsecondsSinceEpoch}';
    final orderCode = 'PED-2026-${orderNumber.toString().padLeft(3, '0')}';
    final rawLines = (quote['lines'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);
    final orderLines = rawLines
        .map((line) {
          final productId = line['product_id'] as String? ?? '';
          final productIndex = _products.indexWhere(
            (item) => item['id'] == productId,
          );
          final currentStock = productIndex == -1
              ? 0
              : (_products[productIndex]['stock'] as num?)?.toInt() ?? 0;

          return <String, dynamic>{
            'product_id': productId,
            'product_sku': line['product_sku'] as String? ?? '',
            'product_name': line['product_name'] as String? ?? '',
            'product_category': line['product_category'] as String? ?? '',
            'unit': line['unit'] as String? ?? '',
            'quantity': (line['quantity'] as num?)?.toInt() ?? 0,
            'unit_price': (line['unit_price'] as num?)?.toDouble() ?? 0,
            'line_total': (line['line_total'] as num?)?.toDouble() ?? 0,
            'stock_available': currentStock,
          };
        })
        .toList(growable: false);

    final promisedDate = quote['valid_until'] as String? ?? '';
    _orders.insert(0, <String, dynamic>{
      'id': orderId,
      'code': orderCode,
      'quote_id': quote['id'] as String? ?? '',
      'quote_code': quote['code'] as String? ?? '',
      'customer_name': quote['customer_name'] as String? ?? '',
      'status': 'Nuevo',
      'total': (quote['total'] as num?)?.toDouble() ?? 0,
      'created_at': DateTime.now().toIso8601String().split('T').first,
      'promised_date': promisedDate,
      'shipped_at': null,
      'delivered_at': null,
      'inventory_reserved': false,
      'lines': orderLines,
    });

    _quotes[quoteIndex] = <String, dynamic>{
      ..._quotes[quoteIndex],
      'status': 'Convertida',
      'order_id': orderId,
    };

    _activities.insert(0, <String, dynamic>{
      'id': 'act-${DateTime.now().microsecondsSinceEpoch}',
      'type': 'Pedido',
      'summary':
          'Cotizacion ${_quotes[quoteIndex]['code']} convertida a pedido $orderCode.',
      'owner': 'Erick Ramirez',
      'created_at': DateTime.now().toUtc().toIso8601String(),
    });

    return <String, dynamic>{'ok': true, 'order_id': orderId};
  }

  Map<String, dynamic> updateOrderStatus({
    required String id,
    required String status,
  }) {
    final index = _orders.indexWhere((order) => order['id'] == id);
    if (index == -1) {
      return <String, dynamic>{'ok': false, 'message': 'Pedido no encontrado.'};
    }

    final normalizedStatus = status.trim().isEmpty ? 'Nuevo' : status.trim();
    final current = _orders[index];
    final currentStatus = current['status'] as String? ?? 'Nuevo';
    var inventoryReserved = current['inventory_reserved'] as bool? ?? false;

    if (normalizedStatus == currentStatus) {
      return <String, dynamic>{'ok': true};
    }

    if (normalizedStatus == 'En surtido' && !inventoryReserved) {
      final reserveResult = _reserveInventoryForOrder(index);
      if (!(reserveResult['ok'] as bool? ?? false)) {
        return reserveResult;
      }
      inventoryReserved = true;
    }

    if (normalizedStatus == 'Enviado' && !inventoryReserved) {
      final reserveResult = _reserveInventoryForOrder(index);
      if (!(reserveResult['ok'] as bool? ?? false)) {
        return reserveResult;
      }
      inventoryReserved = true;
    }

    if (normalizedStatus == 'Cancelado' && inventoryReserved) {
      _releaseInventoryForOrder(index);
      inventoryReserved = false;
    }

    _orders[index] = <String, dynamic>{
      ..._orders[index],
      'status': normalizedStatus,
      'inventory_reserved': inventoryReserved,
      'shipped_at': normalizedStatus == 'Enviado'
          ? DateTime.now().toIso8601String().split('T').first
          : _orders[index]['shipped_at'],
      'delivered_at': normalizedStatus == 'Entregado'
          ? DateTime.now().toIso8601String().split('T').first
          : _orders[index]['delivered_at'],
    };

    return <String, dynamic>{'ok': true};
  }

  Map<String, dynamic> _reserveInventoryForOrder(int orderIndex) {
    final order = _orders[orderIndex];
    final lines = (order['lines'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    final shortages = <String>[];
    for (final line in lines) {
      final productId = line['product_id'] as String? ?? '';
      final qty = (line['quantity'] as num?)?.toInt() ?? 0;
      final productIndex = _products.indexWhere(
        (item) => item['id'] == productId,
      );
      if (productIndex == -1) {
        shortages.add(line['product_name'] as String? ?? 'Producto');
        continue;
      }
      final stock = (_products[productIndex]['stock'] as num?)?.toInt() ?? 0;
      if (qty > stock) {
        shortages.add("${line['product_name']} (faltan ${qty - stock})");
      }
    }

    if (shortages.isNotEmpty) {
      return <String, dynamic>{
        'ok': false,
        'message': 'Inventario insuficiente: ${shortages.join(', ')}',
      };
    }

    final updatedLines = <Map<String, dynamic>>[];
    for (final line in lines) {
      final productId = line['product_id'] as String? ?? '';
      final qty = (line['quantity'] as num?)?.toInt() ?? 0;
      final productIndex = _products.indexWhere(
        (item) => item['id'] == productId,
      );
      if (productIndex == -1) {
        updatedLines.add(line);
        continue;
      }
      final stock = (_products[productIndex]['stock'] as num?)?.toInt() ?? 0;
      final nextStock = max(0, stock - qty);
      _products[productIndex] = <String, dynamic>{
        ..._products[productIndex],
        'stock': nextStock,
      };
      updatedLines.add(<String, dynamic>{
        ...line,
        'stock_available': nextStock,
      });
    }

    _orders[orderIndex] = <String, dynamic>{...order, 'lines': updatedLines};

    return <String, dynamic>{'ok': true};
  }

  void _releaseInventoryForOrder(int orderIndex) {
    final order = _orders[orderIndex];
    final lines = (order['lines'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);

    final updatedLines = <Map<String, dynamic>>[];
    for (final line in lines) {
      final productId = line['product_id'] as String? ?? '';
      final qty = (line['quantity'] as num?)?.toInt() ?? 0;
      final productIndex = _products.indexWhere(
        (item) => item['id'] == productId,
      );
      if (productIndex == -1) {
        updatedLines.add(line);
        continue;
      }
      final stock = (_products[productIndex]['stock'] as num?)?.toInt() ?? 0;
      final nextStock = stock + qty;
      _products[productIndex] = <String, dynamic>{
        ..._products[productIndex],
        'stock': nextStock,
      };
      updatedLines.add(<String, dynamic>{
        ...line,
        'stock_available': nextStock,
      });
    }

    _orders[orderIndex] = <String, dynamic>{...order, 'lines': updatedLines};
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
      'last_movement_date': DateTime.now().toIso8601String().split('T').first,
    };

    var customerCreated = false;
    var customerName = '';
    if (stage == OpportunityStage.won.code) {
      final wonOpportunity = _opportunities[index];
      customerName = (wonOpportunity['customer_name'] as String? ?? '').trim();
      final exists = _customers.any(
        (customer) =>
            ((customer['name'] as String?) ?? '').toLowerCase() ==
            customerName.toLowerCase(),
      );
      if (!exists && customerName.isNotEmpty) {
        final industrialSector =
            (wonOpportunity['industrial_sector'] as String? ?? '').trim();
        final projectState = (wonOpportunity['project_state'] as String? ?? '')
            .trim();
        final projectCity = (wonOpportunity['project_city'] as String? ?? '')
            .trim();
        _customers.insert(0, <String, dynamic>{
          'id': 'cus-${DateTime.now().microsecondsSinceEpoch}',
          'name': customerName,
          'segment': industrialSector.isEmpty
              ? 'Cuenta nueva'
              : industrialSector,
          'industrial_sector': industrialSector,
          'contact_name': 'Contacto por definir',
          'contact_phone': '',
          'city': projectCity.isEmpty ? 'Sin ciudad' : projectCity,
          'project_state': projectState,
          'project_city': projectCity,
          'project_latitude': null,
          'project_longitude': null,
          'credit_status': 'Revision',
        });
        customerCreated = true;
        _activities.insert(0, <String, dynamic>{
          'id': 'act-${DateTime.now().millisecondsSinceEpoch}',
          'type': 'Cliente',
          'summary': 'Nuevo cliente creado desde deal ganado: $customerName.',
          'owner': 'Erick Ramirez',
          'created_at': DateTime.now().toUtc().toIso8601String(),
        });
      }
    }

    return <String, dynamic>{
      'ok': true,
      'customer_created': customerCreated,
      'customer_name': customerName,
    };
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

  double _defaultProbabilityByStage(OpportunityStage stage) {
    return switch (stage) {
      OpportunityStage.newLead => 0.3,
      OpportunityStage.contacted => 0.4,
      OpportunityStage.requirement => 0.5,
      OpportunityStage.quotation => 0.65,
      OpportunityStage.negotiation => 0.78,
      OpportunityStage.won => 0.95,
      OpportunityStage.lost => 0.1,
    };
  }

  String _moneyCompact(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    }
    return '\$${(value / 1000).toStringAsFixed(0)}K';
  }
}
