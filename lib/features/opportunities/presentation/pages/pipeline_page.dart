import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_toast.dart';
import '../../../../core/design_system/crm_page_shell.dart';
import '../../../activities/presentation/providers/activities_providers.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import '../../../tasks/domain/entities/create_task_input.dart';
import '../../../tasks/presentation/providers/tasks_providers.dart';
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

    final payload = await showModalBottomSheet<_CreateDealSheetResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => const _CreateDealSheet(),
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
      await ref
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
      if (mounted && showSuccessToast) {
        AppToast.success(context, 'Etapa movida a ${stage.label}.');
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

    return CrmPageShell(
      title: 'Deals',
      subtitle: '2 oportunidades asignadas',
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
        data: (items) => RefreshIndicator(
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
              _StageStrip(items: items),
              const SizedBox(height: 12),
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
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
              const SizedBox(height: 18),
            ],
          ),
        ),
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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.panelCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.panelBorder),
      ),
      child: Wrap(
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
      ),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
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
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        opportunity.customerName,
                        style: Theme.of(context).textTheme.bodyLarge,
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
                  ),
                ),
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
        ),
      ),
    );
  }
}

class _CreateDealSheetResult {
  const _CreateDealSheetResult({required this.input});

  final CreateOpportunityInput input;
}

class _CreateDealSheet extends StatefulWidget {
  const _CreateDealSheet();

  @override
  State<_CreateDealSheet> createState() => _CreateDealSheetState();
}

class _CreateDealSheetState extends State<_CreateDealSheet> {
  final _formKey = GlobalKey<FormState>();
  final _customerController = TextEditingController();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  OpportunityStage _selectedStage = OpportunityStage.requirement;
  DateTime _expectedDate = DateTime.now().add(const Duration(days: 14));
  double _probability = 0.5;

  @override
  void dispose() {
    _customerController.dispose();
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

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final amount = _parseAmount(_amountController.text);
    if (amount <= 0) {
      AppToast.info(context, 'Ingresa un monto estimado mayor a 0.');
      return;
    }

    Navigator.of(context).pop(
      _CreateDealSheetResult(
        input: CreateOpportunityInput(
          customerName: _customerController.text.trim(),
          title: _titleController.text.trim(),
          stage: _selectedStage,
          amount: amount,
          probability: _probability,
          expectedCloseDate: DateFormat('yyyy-MM-dd').format(_expectedDate),
        ),
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
              TextFormField(
                controller: _customerController,
                validator: _requiredField,
                decoration: const InputDecoration(
                  labelText: 'Cliente',
                  hintText: 'Empresa cliente',
                ),
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

const _createDealStages = <OpportunityStage>[
  OpportunityStage.newLead,
  OpportunityStage.contacted,
  OpportunityStage.requirement,
  OpportunityStage.quotation,
  OpportunityStage.negotiation,
];

const _taskTypeOptions = <String>[
  'Seguimiento',
  'Llamada',
  'Visita',
  'Cotizacion',
  'Correo',
];
