import 'package:crm_tuberias_valvulas_mobile/core/design_system/card_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_toast.dart';
import '../../../../core/design_system/crm_page_shell.dart';
import '../../../activities/presentation/providers/activities_providers.dart';
import '../../../customers/domain/entities/customer.dart';
import '../../../customers/presentation/providers/customers_providers.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import '../../../tasks/domain/entities/create_task_input.dart';
import '../../../tasks/presentation/providers/tasks_providers.dart';
import '../../../technical_catalog/domain/entities/catalog_product.dart';
import '../../../technical_catalog/domain/entities/technical_datasheet.dart';
import '../../../technical_catalog/presentation/providers/technical_catalog_providers.dart';
import '../../domain/entities/create_opportunity_input.dart';
import '../../domain/entities/opportunity.dart';
import '../providers/opportunities_providers.dart';

class PipelinePage extends ConsumerStatefulWidget {
  const PipelinePage({super.key});

  @override
  ConsumerState<PipelinePage> createState() => _PipelinePageState();
}

class _PipelinePageState extends ConsumerState<PipelinePage> {
  String? _movingOpportunityId;
  String? _creatingTaskOpportunityId;
  bool _creatingOpportunity = false;

  Future<void> _openCreateDealSheet() async {
    if (_creatingOpportunity) {
      return;
    }

    final customers = await ref.read(customersProvider().future);
    if (!mounted) {
      return;
    }
    if (customers.isEmpty) {
      AppToast.info(context, 'No hay clientes registrados para crear deals.');
      return;
    }

    final payload = await showModalBottomSheet<_CreateDealSheetResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => _CreateDealSheet(customers: customers),
    );

    if (!mounted || payload == null) {
      return;
    }

    setState(() => _creatingOpportunity = true);
    try {
      await ref
          .read(opportunitiesControllerProvider.notifier)
          .createOpportunity(payload.input);

      ref.invalidate(dashboardSummaryProvider);
      ref.invalidate(activitiesTimelineControllerProvider);
      if (mounted) {
        AppToast.success(context, 'Deal creado: ${payload.input.title}.');
        if (payload.datasheetsAttached > 0) {
          AppToast.info(
            context,
            'Ficha(s) tecnica(s) adjuntas: ${payload.datasheetsAttached}.',
          );
        }
      }
    } catch (_) {
      if (mounted) {
        AppToast.info(context, 'No se pudo crear el deal.');
      }
    } finally {
      if (mounted) {
        setState(() => _creatingOpportunity = false);
      }
    }
  }

  Future<void> _moveToStage({
    required Opportunity opportunity,
    required OpportunityStage stage,
    required bool showSuccessToast,
  }) async {
    if (_movingOpportunityId != null || stage == opportunity.stage) {
      return;
    }

    setState(() => _movingOpportunityId = opportunity.id);
    try {
      final result = await ref
          .read(opportunitiesControllerProvider.notifier)
          .moveToStage(opportunityId: opportunity.id, stage: stage);
      await ref
          .read(activitiesTimelineControllerProvider.notifier)
          .logInteraction(
            type: 'Pipeline',
            summary:
                'Oportunidad ${opportunity.title} movida a ${stage.label}.',
          );
      ref.invalidate(dashboardSummaryProvider);
      if (result.customerCreated) {
        ref.invalidate(customersProvider());
      }
      if (mounted && showSuccessToast) {
        AppToast.success(context, 'Etapa movida a ${stage.label}.');
        if (result.customerCreated) {
          AppToast.info(
            context,
            'Se creo cliente automaticamente: ${result.customerName}.',
          );
        }
      }
    } catch (_) {
      if (mounted) {
        AppToast.info(context, 'No se pudo mover la etapa.');
      }
    } finally {
      if (mounted) {
        setState(() => _movingOpportunityId = null);
      }
    }
  }

  Future<void> _movePlusOne(Opportunity opportunity) async {
    final next = _nextStage(opportunity.stage);
    if (next == opportunity.stage) {
      AppToast.info(context, 'La oportunidad ya esta en etapa final.');
      return;
    }

    await _moveToStage(
      opportunity: opportunity,
      stage: next,
      showSuccessToast: true,
    );
  }

  Future<void> _openTaskSheet(Opportunity opportunity) async {
    if (_creatingTaskOpportunityId != null) {
      return;
    }

    final payload = await showModalBottomSheet<_OpportunityTaskSheetResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => _OpportunityTaskSheet(opportunity: opportunity),
    );

    if (!mounted || payload == null) {
      return;
    }

    setState(() => _creatingTaskOpportunityId = opportunity.id);
    try {
      await ref
          .read(createTaskUseCaseProvider)
          .call(
            CreateTaskInput(
              title: payload.title,
              type: payload.type,
              dueDate: payload.dueDate,
              relatedTo: opportunity.id,
            ),
          );
      await ref
          .read(activitiesTimelineControllerProvider.notifier)
          .logInteraction(
            type: 'Tarea',
            summary:
                'Seguimiento creado para oportunidad ${opportunity.title}.',
          );

      ref.invalidate(tasksControllerProvider);
      ref.invalidate(dashboardSummaryProvider);
      ref.invalidate(activitiesTimelineControllerProvider);
      if (mounted) {
        AppToast.success(context, 'Tarea de seguimiento creada.');
      }
    } catch (_) {
      if (mounted) {
        AppToast.info(context, 'No se pudo crear la tarea.');
      }
    } finally {
      if (mounted) {
        setState(() => _creatingTaskOpportunityId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final opportunitiesState = ref.watch(opportunitiesControllerProvider);
    final activeCount =
        opportunitiesState.valueOrNull
            ?.where(
              (item) =>
                  item.stage != OpportunityStage.won &&
                  item.stage != OpportunityStage.lost,
            )
            .length ??
        0;

    return CrmPageShell(
      title: 'Deals',
      subtitle: '$activeCount oportunidades activas',
      actions: <Widget>[
        ActionSquare(
          icon: _creatingOpportunity
              ? Icons.hourglass_top_rounded
              : Icons.add_rounded,
          onTap: _creatingOpportunity ? null : _openCreateDealSheet,
        ),
        const SizedBox(width: 8),
        ActionSquare(icon: Icons.search_rounded, onTap: () {}),
        const SizedBox(width: 8),
        ActionSquare(icon: Icons.bar_chart_rounded, onTap: () {}),
      ],
      child: opportunitiesState.when(
        data: (items) {
          final activeItems = items
              .where(
                (item) =>
                    item.stage != OpportunityStage.won &&
                    item.stage != OpportunityStage.lost,
              )
              .toList(growable: false);
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(opportunitiesControllerProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                const SizedBox(height: 8),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.yellow,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onPressed: _creatingOpportunity ? null : _openCreateDealSheet,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Crear deal'),
                ),
                const SizedBox(height: 12),
                CardApp(child: _StageStrip(items: activeItems)),
                const SizedBox(height: 12),
                CardApp(child: _PipelineInactivityAlert(items: activeItems)),
                const SizedBox(height: 12),
                ...activeItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CardApp(
                      child: _OpportunityCard(
                        opportunity: item,
                        isMoving: _movingOpportunityId == item.id,
                        isCreatingTask: _creatingTaskOpportunityId == item.id,
                        onChangeStage: (selected) => _moveToStage(
                          opportunity: item,
                          stage: selected,
                          showSuccessToast: true,
                        ),
                        onMovePlusOne: () => _movePlusOne(item),
                        onCreateTask: () => _openTaskSheet(item),
                      ),
                    ),
                  ),
                ),
                if (activeItems.isEmpty)
                  const CardApp(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'No hay oportunidades activas en el pipeline.',
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Error cargando pipeline: $error')),
      ),
    );
  }
}

class _StageStrip extends StatelessWidget {
  const _StageStrip({required this.items});

  final List<Opportunity> items;

  @override
  Widget build(BuildContext context) {
    final countByStage = <OpportunityStage, int>{
      for (final stage in OpportunityStage.values) stage: 0,
    };

    for (final item in items) {
      countByStage[item.stage] = (countByStage[item.stage] ?? 0) + 1;
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: OpportunityStage.values
          .take(4)
          .map(
            (stage) => Chip(
              backgroundColor: Colors.white,
              side: const BorderSide(color: AppColors.panelBorder),
              avatar: CircleAvatar(
                backgroundColor: AppColors.yellow,

                child: Text(
                  '${countByStage[stage]}',
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              label: Text(stage.label),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  const _OpportunityCard({
    required this.opportunity,
    required this.isMoving,
    required this.isCreatingTask,
    required this.onChangeStage,
    required this.onMovePlusOne,
    required this.onCreateTask,
  });

  final Opportunity opportunity;
  final bool isMoving;
  final bool isCreatingTask;
  final ValueChanged<OpportunityStage> onChangeStage;
  final VoidCallback onMovePlusOne;
  final VoidCallback onCreateTask;

  @override
  Widget build(BuildContext context) {
    final inactiveDays = _daysSinceDate(opportunity.lastMovementDate);
    final hasInactivityAlert =
        inactiveDays >= 5 &&
        opportunity.amount >= 100000 &&
        (opportunity.stage == OpportunityStage.quotation ||
            opportunity.stage == OpportunityStage.negotiation);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    opportunity.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    opportunity.customerName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Text(
              NumberFormat.currency(
                locale: 'es_MX',
                symbol: '\$',
              ).format(opportunity.amount),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: hasInactivityAlert
                    ? Colors.red.shade100
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'Sin movimiento: ${inactiveDays < 0 ? 0 : inactiveDays}d',
                style: TextStyle(
                  color: hasInactivityAlert
                      ? Colors.red.shade900
                      : Colors.black54,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
            if (hasInactivityAlert) ...<Widget>[
              const SizedBox(width: 8),
              Text(
                'Requiere seguimiento',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: LinearProgressIndicator(
                minHeight: 8,
                value: opportunity.probability,
                backgroundColor: Colors.black12,
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(width: 10),
            Text('${(opportunity.probability * 100).toStringAsFixed(0)}%'),
          ],
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<OpportunityStage>(
          initialValue: opportunity.stage,
          decoration: const InputDecoration(
            labelText: 'Etapa comercial',
            border: OutlineInputBorder(),
          ),
          items: OpportunityStage.values
              .map(
                (stage) => DropdownMenuItem<OpportunityStage>(
                  value: stage,
                  child: Text(stage.label),
                ),
              )
              .toList(growable: false),
          onChanged: isMoving
              ? null
              : (selected) {
                  if (selected == null) {
                    return;
                  }
                  onChangeStage(selected);
                },
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.black),
                foregroundColor: AppColors.black,
              ),
              onPressed: isMoving ? null : onMovePlusOne,
              icon: Icon(
                isMoving
                    ? Icons.hourglass_top_rounded
                    : Icons.trending_up_rounded,
                size: 18,
              ),
              label: Text(isMoving ? 'Moviendo...' : 'Mover +1 etapa'),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.black),
                foregroundColor: AppColors.black,
              ),
              onPressed: isCreatingTask ? null : onCreateTask,
              icon: Icon(
                isCreatingTask
                    ? Icons.hourglass_top_rounded
                    : Icons.add_task_rounded,
                size: 18,
              ),
              label: Text(isCreatingTask ? 'Creando...' : 'Crear tarea'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Cierre estimado: ${opportunity.expectedCloseDate}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }
}

class _PipelineInactivityAlert extends StatelessWidget {
  const _PipelineInactivityAlert({required this.items});

  final List<Opportunity> items;

  @override
  Widget build(BuildContext context) {
    final flagged = items
        .where(
          (item) =>
              item.amount >= 100000 &&
              (item.stage == OpportunityStage.quotation ||
                  item.stage == OpportunityStage.negotiation) &&
              _daysSinceDate(item.lastMovementDate) >= 5,
        )
        .toList(growable: false);
    final totalAmount = flagged.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    if (flagged.isEmpty) {
      return Row(
        children: const <Widget>[
          Icon(Icons.check_circle_rounded, color: Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sin alertas de inactividad en cotizaciones de alto valor.',
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Alertas de inactividad: ${flagged.length}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red.shade800,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Monto en riesgo: ${_money(totalAmount)}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
        ),
      ],
    );
  }
}

class _CreateDealSheetResult {
  const _CreateDealSheetResult({
    required this.input,
    required this.datasheetsAttached,
  });

  final CreateOpportunityInput input;
  final int datasheetsAttached;
}

class _CreateDealSheet extends ConsumerStatefulWidget {
  const _CreateDealSheet({required this.customers});

  final List<Customer> customers;

  @override
  ConsumerState<_CreateDealSheet> createState() => _CreateDealSheetState();
}

class _CreateDealSheetState extends ConsumerState<_CreateDealSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  late String _selectedCustomerName;
  late String _selectedIndustrialSector;
  late String _selectedProjectState;
  late String _selectedProjectCity;
  late String _selectedDeliveryTime;
  late String _selectedMainCompetitor;
  late String _selectedProductType;
  late String _selectedMaterial;
  late String _selectedSchedule;
  late String _selectedNominalDiameter;
  late String _selectedEndType;
  late String _selectedValveType;
  late String _selectedPressureClass;
  late String _selectedStandard;
  OpportunityStage _selectedStage = OpportunityStage.requirement;
  DateTime _expectedDate = DateTime.now().add(const Duration(days: 14));
  double _probability = 0.5;

  @override
  void initState() {
    super.initState();
    final firstCustomer = widget.customers.first;
    _selectedCustomerName = firstCustomer.name;
    _selectedIndustrialSector = _matchOption(
      options: _dealIndustrialSectorOptions,
      value: firstCustomer.industrialSector.isEmpty
          ? firstCustomer.segment
          : firstCustomer.industrialSector,
      fallback: _dealIndustrialSectorOptions.first,
    );
    _selectedProjectState = _matchOption(
      options: _dealProjectStateOptions,
      value: firstCustomer.projectState,
      fallback: _dealProjectStateOptions.first,
    );
    _selectedProjectCity = _resolveProjectCity(
      state: _selectedProjectState,
      preferredCity: firstCustomer.projectCity.isEmpty
          ? firstCustomer.city
          : firstCustomer.projectCity,
    );
    _selectedDeliveryTime = _dealDeliveryTimeOptions[2];
    _selectedMainCompetitor = _dealCompetitorOptions.first;
    _selectedProductType = _catalogProductTypeOptions.first;
    _selectedMaterial = _technicalMaterialOptions.first;
    _selectedSchedule = _technicalScheduleOptions.first;
    _selectedNominalDiameter = _technicalNominalDiameterOptions[2];
    _selectedEndType = _technicalEndTypeOptions.first;
    _selectedValveType = _technicalValveTypeOptions.first;
    _selectedPressureClass = _technicalPressureClassOptions.first;
    _selectedStandard = _technicalStandardOptions.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _onStageChanged(OpportunityStage stage) {
    setState(() {
      _selectedStage = stage;
      _probability = _defaultProbabilityForStage(stage);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) {
      setState(() => _expectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final amount = _parseAmount(_amountController.text);
    if (amount <= 0) {
      AppToast.info(context, 'Ingresa un monto estimado mayor a 0.');
      return;
    }

    final datasheets = await ref.read(
      technicalCatalogDatasheetsProvider(
        material: _selectedMaterial,
        valveType: _normalizedValveType(),
        standard: _selectedStandard,
        productType: _selectedProductType,
      ).future,
    );
    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(
      _CreateDealSheetResult(
        input: CreateOpportunityInput(
          customerName: _selectedCustomerName,
          title: _titleController.text.trim(),
          stage: _selectedStage,
          amount: amount,
          probability: _probability,
          expectedCloseDate: DateFormat('yyyy-MM-dd').format(_expectedDate),
          industrialSector: _selectedIndustrialSector,
          projectState: _selectedProjectState,
          projectCity: _selectedProjectCity,
          requiredDeliveryTime: _selectedDeliveryTime,
          mainCompetitor: _selectedMainCompetitor,
          material: _selectedMaterial,
          schedule: _selectedSchedule,
          nominalDiameter: _selectedNominalDiameter,
          endType: _selectedEndType,
          valveType: _normalizedValveType() ?? '',
          pressureClass: _selectedPressureClass,
          standard: _selectedStandard,
        ),
        datasheetsAttached: datasheets.length,
      ),
    );
  }

  Customer? _findCustomerByName(String name) {
    for (final customer in widget.customers) {
      if (customer.name == name) {
        return customer;
      }
    }
    return null;
  }

  String _matchOption({
    required List<String> options,
    required String? value,
    required String fallback,
  }) {
    final normalized = (value ?? '').trim().toLowerCase();
    for (final option in options) {
      if (option.toLowerCase() == normalized) {
        return option;
      }
    }
    return fallback;
  }

  String _resolveProjectCity({
    required String state,
    required String? preferredCity,
  }) {
    final cities = _dealProjectCitiesByState[state] ?? const <String>[];
    if (cities.isEmpty) {
      return '';
    }
    final normalizedCity = (preferredCity ?? '').trim().toLowerCase();
    for (final city in cities) {
      if (city.toLowerCase() == normalizedCity) {
        return city;
      }
    }
    return cities.first;
  }

  String? _normalizedValveType() {
    if (_selectedValveType == 'N/A') {
      return null;
    }
    return _selectedValveType;
  }

  void _applyAiSuggestion() {
    switch (_selectedIndustrialSector) {
      case 'Mineria':
        _selectedProductType = 'Valvula';
        _selectedMaterial = 'Acero al Carbon';
        _selectedSchedule = 'Sch 80';
        _selectedNominalDiameter = '6"';
        _selectedEndType = 'Bridado';
        _selectedValveType = 'Compuerta';
        _selectedPressureClass = '600';
        _selectedStandard = 'API';
        _selectedDeliveryTime = '2-4 semanas';
        break;
      case 'Gas y Petroleo':
        _selectedProductType = 'Valvula';
        _selectedMaterial = 'Inoxidable';
        _selectedSchedule = 'Sch 80';
        _selectedNominalDiameter = '8"';
        _selectedEndType = 'Bridado';
        _selectedValveType = 'Compuerta';
        _selectedPressureClass = '600';
        _selectedStandard = 'API';
        _selectedDeliveryTime = '4-6 semanas';
        break;
      case 'Hidraulica':
        _selectedProductType = 'Tuberia';
        _selectedMaterial = 'Acero al Carbon';
        _selectedSchedule = 'Sch 40';
        _selectedNominalDiameter = '4"';
        _selectedEndType = 'Bridado';
        _selectedValveType = 'Check';
        _selectedPressureClass = '300';
        _selectedStandard = 'ASTM';
        _selectedDeliveryTime = '2-4 semanas';
        break;
      default:
        _selectedProductType = 'Valvula';
        _selectedMaterial = 'Acero al Carbon';
        _selectedSchedule = 'Sch 40';
        _selectedNominalDiameter = '3"';
        _selectedEndType = 'Bridado';
        _selectedValveType = 'Compuerta';
        _selectedPressureClass = '300';
        _selectedStandard = 'ANSI';
        _selectedDeliveryTime = '2-4 semanas';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final compatibleProductsState = ref.watch(
      technicalCatalogProductsProvider(
        material: _selectedMaterial,
        valveType: _normalizedValveType(),
        standard: _selectedStandard,
        productType: _selectedProductType,
      ),
    );
    final datasheetsState = ref.watch(
      technicalCatalogDatasheetsProvider(
        material: _selectedMaterial,
        valveType: _normalizedValveType(),
        standard: _selectedStandard,
        productType: _selectedProductType,
      ),
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 66,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.panelBorder,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Nuevo deal',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Registra una nueva oportunidad en el pipeline.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              FormField<String>(
                initialValue: _selectedCustomerName,
                validator: _requiredField,
                builder: (field) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final selected = await showModalBottomSheet<String>(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        backgroundColor: AppColors.panel,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        builder: (_) => _CustomerPickerSheet(
                          customers: widget.customers,
                          selectedName: _selectedCustomerName,
                        ),
                      );
                      if (selected != null) {
                        setState(() {
                          _selectedCustomerName = selected;
                          final selectedCustomer = _findCustomerByName(
                            selected,
                          );
                          if (selectedCustomer != null) {
                            _selectedIndustrialSector = _matchOption(
                              options: _dealIndustrialSectorOptions,
                              value: selectedCustomer.industrialSector.isEmpty
                                  ? selectedCustomer.segment
                                  : selectedCustomer.industrialSector,
                              fallback: _selectedIndustrialSector,
                            );
                            _selectedProjectState = _matchOption(
                              options: _dealProjectStateOptions,
                              value: selectedCustomer.projectState,
                              fallback: _selectedProjectState,
                            );
                            _selectedProjectCity = _resolveProjectCity(
                              state: _selectedProjectState,
                              preferredCity:
                                  selectedCustomer.projectCity.isEmpty
                                  ? selectedCustomer.city
                                  : selectedCustomer.projectCity,
                            );
                          }
                        });
                        field.didChange(selected);
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Cliente',
                        errorText: field.errorText,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _selectedCustomerName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Icon(Icons.search_rounded, size: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                validator: _requiredField,
                decoration: const InputDecoration(
                  labelText: 'Titulo',
                  hintText: 'Proyecto o requerimiento',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedIndustrialSector,
                      decoration: const InputDecoration(
                        labelText: 'Giro industrial',
                      ),
                      items: _dealIndustrialSectorOptions
                          .map(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedIndustrialSector = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedProjectState,
                      decoration: const InputDecoration(
                        labelText: 'Estado proyecto',
                      ),
                      items: _dealProjectStateOptions
                          .map(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedProjectState = value;
                            _selectedProjectCity = _resolveProjectCity(
                              state: value,
                              preferredCity: null,
                            );
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cityField = DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _selectedProjectCity,
                    decoration: const InputDecoration(
                      labelText: 'Ciudad proyecto',
                    ),
                    items:
                        (_dealProjectCitiesByState[_selectedProjectState] ??
                                const <String>[])
                            .map(
                              (value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(growable: false),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedProjectCity = value);
                      }
                    },
                  );
                  final deliveryField = DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _selectedDeliveryTime,
                    decoration: const InputDecoration(
                      labelText: 'Tiempo entrega',
                    ),
                    items: _dealDeliveryTimeOptions
                        .map(
                          (value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedDeliveryTime = value);
                      }
                    },
                  );

                  if (constraints.maxWidth < 420) {
                    return Column(
                      children: <Widget>[
                        cityField,
                        const SizedBox(height: 10),
                        deliveryField,
                      ],
                    );
                  }

                  return Row(
                    children: <Widget>[
                      Expanded(child: cityField),
                      const SizedBox(width: 10),
                      Expanded(child: deliveryField),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _selectedMainCompetitor,
                decoration: const InputDecoration(
                  labelText: 'Competidor principal',
                ),
                items: _dealCompetitorOptions
                    .map(
                      (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedMainCompetitor = value);
                  }
                },
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.panelBorder),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.auto_awesome_rounded),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Sugerencia IA mock para configuracion tecnica.',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(_applyAiSuggestion);
                      },
                      child: const Text('Aplicar'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _selectedProductType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de producto',
                ),
                items: _catalogProductTypeOptions
                    .map(
                      (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedProductType = value);
                  }
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedMaterial,
                      decoration: const InputDecoration(labelText: 'Material'),
                      items: _technicalMaterialOptions
                          .map(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedMaterial = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedSchedule,
                      decoration: const InputDecoration(labelText: 'Cedula'),
                      items: _technicalScheduleOptions
                          .map(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedSchedule = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedNominalDiameter,
                      decoration: const InputDecoration(
                        labelText: 'Diametro nominal',
                      ),
                      items: _technicalNominalDiameterOptions
                          .map(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedNominalDiameter = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedEndType,
                      decoration: const InputDecoration(
                        labelText: 'Tipo extremo',
                      ),
                      items: _technicalEndTypeOptions
                          .map(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedEndType = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedValveType,
                      decoration: const InputDecoration(
                        labelText: 'Tipo valvula',
                      ),
                      items: _technicalValveTypeOptions
                          .map(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedValveType = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _selectedPressureClass,
                      decoration: const InputDecoration(
                        labelText: 'Clase/presion',
                      ),
                      items: _technicalPressureClassOptions
                          .map(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedPressureClass = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _selectedStandard,
                decoration: const InputDecoration(labelText: 'Normatividad'),
                items: _technicalStandardOptions
                    .map(
                      (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedStandard = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              CardApp(
                child: _CatalogPreviewSection(
                  productsState: compatibleProductsState,
                  datasheetsState: datasheetsState,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      validator: _requiredField,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Monto estimado',
                        hintText: '120000',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<OpportunityStage>(
                      initialValue: _selectedStage,
                      decoration: const InputDecoration(labelText: 'Etapa'),
                      items: _createDealStages
                          .map(
                            (stage) => DropdownMenuItem<OpportunityStage>(
                              value: stage,
                              child: Text(stage.label),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (stage) {
                        if (stage != null) {
                          _onStageChanged(stage);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Cierre estimado',
                  ),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(_expectedDate),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Probabilidad (${(_probability * 100).toStringAsFixed(0)}%)',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Slider(
                value: _probability,
                min: 0.05,
                max: 0.95,
                divisions: 18,
                activeColor: AppColors.black,
                inactiveColor: AppColors.panelBorder,
                label: '${(_probability * 100).toStringAsFixed(0)}%',
                onChanged: (value) {
                  setState(() => _probability = value);
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: AppColors.yellow,
                      ),
                      onPressed: _submit,
                      child: const Text('Guardar deal'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogPreviewSection extends StatelessWidget {
  const _CatalogPreviewSection({
    required this.productsState,
    required this.datasheetsState,
  });

  final AsyncValue<List<CatalogProduct>> productsState;
  final AsyncValue<List<TechnicalDatasheet>> datasheetsState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Catalogo tecnico sugerido',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        productsState.when(
          data: (items) => Text('Productos compatibles: ${items.length}'),
          loading: () => const Text('Buscando productos compatibles...'),
          error: (_, _) => const Text('No se pudieron cargar productos.'),
        ),
        const SizedBox(height: 6),
        datasheetsState.when(
          data: (items) {
            if (items.isEmpty) {
              return const Text(
                'Sin fichas automaticas para esta combinacion tecnica.',
              );
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items
                  .map(
                    (sheet) => Chip(
                      avatar: const Icon(
                        Icons.picture_as_pdf_rounded,
                        size: 18,
                      ),
                      label: Text(sheet.title, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(growable: false),
            );
          },
          loading: () => const Text('Preparando fichas tecnicas...'),
          error: (_, _) => const Text('No se pudieron cargar fichas tecnicas.'),
        ),
      ],
    );
  }
}

class _OpportunityTaskSheetResult {
  const _OpportunityTaskSheetResult({
    required this.title,
    required this.type,
    required this.dueDate,
  });

  final String title;
  final String type;
  final String dueDate;
}

class _CustomerPickerSheet extends StatefulWidget {
  const _CustomerPickerSheet({
    required this.customers,
    required this.selectedName,
  });

  final List<Customer> customers;
  final String selectedName;

  @override
  State<_CustomerPickerSheet> createState() => _CustomerPickerSheetState();
}

class _CustomerPickerSheetState extends State<_CustomerPickerSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = widget.customers
        .where(
          (customer) =>
              customer.name.toLowerCase().contains(query) ||
              customer.contactName.toLowerCase().contains(query),
        )
        .toList(growable: false);

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.72,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 66,
              height: 7,
              decoration: BoxDecoration(
                color: AppColors.panelBorder,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              'Seleccionar cliente',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                labelText: 'Buscar cliente',
                hintText: 'Nombre de empresa o contacto',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final customer = filtered[index];
                final selected = customer.name == widget.selectedName;
                return ListTile(
                  onTap: () => Navigator.of(context).pop(customer.name),
                  leading: Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: AppColors.black,
                  ),
                  title: Text(customer.name),
                  subtitle: Text('${customer.contactName} • ${customer.city}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityTaskSheet extends StatefulWidget {
  const _OpportunityTaskSheet({required this.opportunity});

  final Opportunity opportunity;

  @override
  State<_OpportunityTaskSheet> createState() => _OpportunityTaskSheetState();
}

class _OpportunityTaskSheetState extends State<_OpportunityTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  String _selectedType = _taskTypeOptions.first;
  late DateTime _selectedDueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: 'Seguimiento oportunidad ${widget.opportunity.title}',
    );
    _selectedDueDate =
        DateTime.tryParse(widget.opportunity.expectedCloseDate) ??
        DateTime.now().add(const Duration(days: 2));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) {
      setState(() => _selectedDueDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    Navigator.of(context).pop(
      _OpportunityTaskSheetResult(
        title: _titleController.text.trim(),
        type: _selectedType,
        dueDate: DateFormat('yyyy-MM-dd').format(_selectedDueDate),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 66,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.panelBorder,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Nueva tarea',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Deal: ${widget.opportunity.title}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                validator: _requiredField,
                decoration: const InputDecoration(
                  labelText: 'Titulo',
                  hintText: 'Seguimiento de propuesta',
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: _taskTypeOptions
                    .map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    })
                    .toList(growable: false),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedType = value);
                  }
                },
              ),
              const SizedBox(height: 10),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Fecha limite'),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(_selectedDueDate),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: AppColors.yellow,
                      ),
                      onPressed: _submit,
                      child: const Text('Crear tarea'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

OpportunityStage _nextStage(OpportunityStage current) {
  final progression = <OpportunityStage>[
    OpportunityStage.newLead,
    OpportunityStage.contacted,
    OpportunityStage.requirement,
    OpportunityStage.quotation,
    OpportunityStage.negotiation,
    OpportunityStage.won,
  ];

  final index = progression.indexOf(current);
  if (index == -1 || index == progression.length - 1) {
    return current;
  }
  return progression[index + 1];
}

String? _requiredField(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Campo obligatorio';
  }
  return null;
}

double _defaultProbabilityForStage(OpportunityStage stage) {
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

double _parseAmount(String raw) {
  final normalized = raw
      .replaceAll(RegExp(r'[^0-9\.\,]'), '')
      .replaceAll(',', '');
  return double.tryParse(normalized) ?? 0;
}

int _daysSinceDate(String rawDate) {
  final parsed = DateTime.tryParse(rawDate);
  if (parsed == null) {
    return 0;
  }
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(parsed.year, parsed.month, parsed.day);
  return today.difference(date).inDays;
}

String _money(double value) {
  return NumberFormat.currency(locale: 'es_MX', symbol: '\$').format(value);
}

const _createDealStages = <OpportunityStage>[
  OpportunityStage.newLead,
  OpportunityStage.contacted,
  OpportunityStage.requirement,
  OpportunityStage.quotation,
  OpportunityStage.negotiation,
];

const _dealIndustrialSectorOptions = <String>[
  'Construccion',
  'Mineria',
  'Energia',
  'Hidraulica',
  'Gas y Petroleo',
  'Alimenticia',
  'Manufactura',
];

const _dealProjectStateOptions = <String>[
  'Nuevo Leon',
  'Jalisco',
  'Ciudad de Mexico',
  'Estado de Mexico',
  'Veracruz',
  'Puebla',
  'Queretaro',
  'Guanajuato',
  'Sinaloa',
  'Baja California',
];

const _dealProjectCitiesByState = <String, List<String>>{
  'Nuevo Leon': <String>['Monterrey', 'San Nicolas', 'Apodaca'],
  'Jalisco': <String>['Guadalajara', 'Zapopan', 'Tlaquepaque'],
  'Ciudad de Mexico': <String>['Alvaro Obregon', 'Azcapotzalco', 'Iztapalapa'],
  'Estado de Mexico': <String>['Toluca', 'Naucalpan', 'Tlalnepantla'],
  'Veracruz': <String>['Veracruz', 'Coatzacoalcos', 'Poza Rica'],
  'Puebla': <String>['Puebla', 'Tehuacan', 'San Martin Texmelucan'],
  'Queretaro': <String>['Queretaro', 'San Juan del Rio', 'El Marques'],
  'Guanajuato': <String>['Leon', 'Irapuato', 'Celaya'],
  'Sinaloa': <String>['Culiacan', 'Mazatlan', 'Los Mochis'],
  'Baja California': <String>['Tijuana', 'Mexicali', 'Ensenada'],
};

const _dealDeliveryTimeOptions = <String>[
  'Inmediato',
  '24-72 horas',
  '2-4 semanas',
  '4-6 semanas',
  '6-8 semanas',
];

const _dealCompetitorOptions = <String>[
  'Sin definir',
  'Distribuidora del Norte',
  'Aceros del Pacifico',
  'Proveedor Local X',
  'Importador directo',
];

const _catalogProductTypeOptions = <String>[
  'Valvula',
  'Tuberia',
  'Conexion',
  'Accesorio',
];

const _technicalMaterialOptions = <String>[
  'Acero al Carbon',
  'Inoxidable',
  'PVC',
  'CPVC',
];

const _technicalScheduleOptions = <String>['Sch 40', 'Sch 80', 'Sch 160'];

const _technicalNominalDiameterOptions = <String>[
  '2"',
  '3"',
  '4"',
  '6"',
  '8"',
  '10"',
  '12"',
];

const _technicalEndTypeOptions = <String>['Bridado', 'Roscado', 'Biselado'];

const _technicalValveTypeOptions = <String>[
  'Compuerta',
  'Bola',
  'Check',
  'Mariposa',
  'N/A',
];

const _technicalPressureClassOptions = <String>['150', '300', '600', '900'];

const _technicalStandardOptions = <String>['ANSI', 'API', 'ASTM'];

const _taskTypeOptions = <String>[
  'Seguimiento',
  'Llamada',
  'Visita',
  'Cotizacion',
  'Correo',
];
