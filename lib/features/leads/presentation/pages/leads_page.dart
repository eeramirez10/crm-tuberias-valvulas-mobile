import 'package:crm_tuberias_valvulas_mobile/core/design_system/card_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_toast.dart';
import '../../../../core/design_system/crm_page_shell.dart';
import '../../../activities/presentation/providers/activities_providers.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import '../../../tasks/domain/entities/create_task_input.dart';
import '../../../tasks/presentation/providers/tasks_providers.dart';
import '../../domain/entities/create_lead_input.dart';
import '../../domain/entities/lead.dart';
import '../../domain/entities/update_lead_input.dart';
import '../providers/leads_providers.dart';

class LeadsPage extends ConsumerStatefulWidget {
  const LeadsPage({super.key});

  @override
  ConsumerState<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends ConsumerState<LeadsPage> {
  bool _creatingLead = false;
  String? _updatingLeadId;
  String? _creatingTaskLeadId;

  Future<void> _openCreateLeadSheet() async {
    if (_creatingLead) {
      return;
    }

    final payload = await showModalBottomSheet<_CreateLeadSheetResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => const _CreateLeadSheet(),
    );

    if (!mounted || payload == null) {
      return;
    }

    setState(() => _creatingLead = true);
    try {
      final lead = await ref
          .read(createLeadUseCaseProvider)
          .call(payload.input);

      if (payload.createInitialTask) {
        await _createTaskForLead(
          lead: lead,
          title: 'Seguimiento inicial ${lead.companyName}',
          type: 'Seguimiento',
          dueDate: lead.nextActionDate,
          showSuccessToast: false,
        );
      }

      ref.invalidate(leadsProvider());
      ref.invalidate(dashboardSummaryProvider);
      ref.invalidate(activitiesTimelineControllerProvider);

      if (mounted) {
        AppToast.success(context, 'Prospecto creado: ${lead.companyName}');
      }
    } catch (_) {
      if (mounted) {
        AppToast.info(context, 'No se pudo registrar el prospecto.');
      }
    } finally {
      if (mounted) {
        setState(() => _creatingLead = false);
      }
    }
  }

  Future<void> _openEditLeadSheet(Lead lead) async {
    if (_updatingLeadId != null) {
      return;
    }

    final payload = await showModalBottomSheet<_UpdateLeadSheetResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => _UpdateLeadSheet(lead: lead),
    );

    if (!mounted || payload == null) {
      return;
    }

    await _updateLead(payload.input, successMessage: 'Prospecto actualizado.');
  }

  Future<void> _changeLeadStatus(Lead lead, String nextStatus) async {
    if (lead.status == nextStatus || _updatingLeadId != null) {
      return;
    }

    await _updateLead(
      _leadToUpdateInput(lead, status: nextStatus),
      successMessage: 'Etapa actualizada a $nextStatus.',
    );
  }

  Future<void> _updateLead(
    UpdateLeadInput input, {
    required String successMessage,
  }) async {
    setState(() => _updatingLeadId = input.leadId);
    try {
      await ref.read(updateLeadUseCaseProvider).call(input);
      ref.invalidate(leadsProvider());
      ref.invalidate(dashboardSummaryProvider);
      ref.invalidate(activitiesTimelineControllerProvider);
      if (mounted) {
        AppToast.success(context, successMessage);
      }
    } catch (_) {
      if (mounted) {
        AppToast.info(context, 'No se pudo actualizar el prospecto.');
      }
    } finally {
      if (mounted) {
        setState(() => _updatingLeadId = null);
      }
    }
  }

  Future<void> _openTaskSheet(Lead lead) async {
    if (_creatingTaskLeadId != null) {
      return;
    }

    final payload = await showModalBottomSheet<_LeadTaskSheetResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.panel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => _LeadTaskSheet(lead: lead),
    );

    if (!mounted || payload == null) {
      return;
    }

    await _createTaskForLead(
      lead: lead,
      title: payload.title,
      type: payload.type,
      dueDate: payload.dueDate,
      showSuccessToast: true,
    );
  }

  Future<void> _createTaskForLead({
    required Lead lead,
    required String title,
    required String type,
    required String dueDate,
    required bool showSuccessToast,
  }) async {
    setState(() => _creatingTaskLeadId = lead.id);
    try {
      await ref
          .read(createTaskUseCaseProvider)
          .call(
            CreateTaskInput(
              title: title,
              type: type,
              dueDate: dueDate,
              relatedTo: lead.id,
            ),
          );
      ref.invalidate(tasksControllerProvider);
      ref.invalidate(dashboardSummaryProvider);
      ref.invalidate(activitiesTimelineControllerProvider);
      if (mounted && showSuccessToast) {
        AppToast.success(context, 'Tarea creada para ${lead.companyName}.');
      }
    } catch (_) {
      if (mounted) {
        AppToast.info(context, 'No se pudo crear la tarea.');
      }
    } finally {
      if (mounted) {
        setState(() => _creatingTaskLeadId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final leadsState = ref.watch(leadsProvider());

    return CrmPageShell(
      title: 'Leads',
      subtitle: 'Leads asignados',
      actions: <Widget>[
        ActionSquare(
          icon: _creatingLead
              ? Icons.hourglass_top_rounded
              : Icons.person_add_alt_1_rounded,
          onTap: _creatingLead ? null : _openCreateLeadSheet,
        ),
        const SizedBox(width: 8),
        ActionSquare(icon: Icons.search_rounded, onTap: () {}),
        const SizedBox(width: 8),
        ActionSquare(icon: Icons.bar_chart_rounded, onTap: () {}),
      ],
      child: leadsState.when(
        data: (items) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(leadsProvider());
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
                onPressed: _creatingLead ? null : _openCreateLeadSheet,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Dar de alta prospecto'),
              ),
              const SizedBox(height: 12),
              CardApp(child: _LeadFilters(items: items)),
              const SizedBox(height: 12),
              ...items.map(
                (lead) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CardApp(
                    child: _LeadCard(
                      lead: lead,
                      isUpdating: _updatingLeadId == lead.id,
                      isCreatingTask: _creatingTaskLeadId == lead.id,
                      onEdit: () => _openEditLeadSheet(lead),
                      onChangeStatus: (status) =>
                          _changeLeadStatus(lead, status),
                      onCreateTask: () => _openTaskSheet(lead),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Error cargando leads: $error')),
      ),
    );
  }
}

class _LeadFilters extends StatelessWidget {
  const _LeadFilters({required this.items});

  final List<Lead> items;

  @override
  Widget build(BuildContext context) {
    final byStatus = <String, int>{};
    for (final item in items) {
      byStatus[item.status] = (byStatus[item.status] ?? 0) + 1;
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        Chip(
          label: Text('All (${items.length})'),
          backgroundColor: AppColors.yellow,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
        ...byStatus.entries.map(
          (entry) => Chip(
            label: Text('${entry.key} (${entry.value})'),
            backgroundColor: Colors.white,
            side: const BorderSide(color: AppColors.panelBorder),
          ),
        ),
      ],
    );
  }
}

class _LeadCard extends ConsumerWidget {
  const _LeadCard({
    required this.lead,
    required this.isUpdating,
    required this.isCreatingTask,
    required this.onEdit,
    required this.onChangeStatus,
    required this.onCreateTask,
  });

  final Lead lead;
  final bool isUpdating;
  final bool isCreatingTask;
  final VoidCallback onEdit;
  final ValueChanged<String> onChangeStatus;
  final VoidCallback onCreateTask;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amount = NumberFormat.currency(
      locale: 'es_MX',
      symbol: '\$',
    ).format(lead.estimatedAmount);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.push('/leads/${lead.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.yellow.withValues(alpha: 0.32),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person_add_alt_1_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      lead.contactName.isEmpty ? lead.owner : lead.contactName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lead.companyName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  PopupMenuButton<String>(
                    enabled: !isUpdating,
                    onSelected: onChangeStatus,
                    itemBuilder: (context) => _leadStatusOptions
                        .map(
                          (status) => PopupMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(growable: false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            lead.status.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.yellow,
                              fontWeight: FontWeight.w900,
                              fontSize: 9,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: AppColors.yellow,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: isUpdating ? null : onEdit,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        isUpdating
                            ? Icons.hourglass_top_rounded
                            : Icons.edit_rounded,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              const Icon(
                Icons.source_outlined,
                size: 18,
                color: Colors.black54,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Fuente: ${lead.source}',
                  style: const TextStyle(color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                amount,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              const Icon(Icons.schedule, size: 18, color: Colors.black54),
              const SizedBox(width: 6),
              Text('Follow up: ${lead.nextActionDate}'),
              const Spacer(),
              const Icon(Icons.arrow_forward_rounded),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.call_outlined,
                  label: 'Llamar',
                  onTap: () async {
                    await ref
                        .read(activitiesTimelineControllerProvider.notifier)
                        .logInteraction(
                          type: 'Llamada',
                          summary:
                              'Llamada simulada a ${lead.contactName.isEmpty ? lead.owner : lead.contactName} (${lead.companyName}).',
                        );
                    if (context.mounted) {
                      AppToast.info(
                        context,
                        'Simulacion: llamada a ${lead.contactName.isEmpty ? lead.owner : lead.contactName}.',
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'WhatsApp',
                  onTap: () async {
                    await ref
                        .read(activitiesTimelineControllerProvider.notifier)
                        .logInteraction(
                          type: 'WhatsApp',
                          summary:
                              'WhatsApp simulado enviado a ${lead.contactName.isEmpty ? lead.owner : lead.contactName} por lead ${lead.companyName}.',
                        );
                    if (context.mounted) {
                      AppToast.info(
                        context,
                        'Simulacion: WhatsApp enviado a ${lead.contactName.isEmpty ? lead.owner : lead.contactName}.',
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickActionButton(
                  icon: isCreatingTask
                      ? Icons.hourglass_top_rounded
                      : Icons.add_task_rounded,
                  label: isCreatingTask ? 'Creando' : 'Tarea',
                  onTap: isCreatingTask ? null : onCreateTask,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.black),
        foregroundColor: AppColors.black,
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label, overflow: TextOverflow.ellipsis),
    );
  }
}

class _CreateLeadSheetResult {
  const _CreateLeadSheetResult({
    required this.input,
    required this.createInitialTask,
  });

  final CreateLeadInput input;
  final bool createInitialTask;
}

class _CreateLeadSheet extends StatefulWidget {
  const _CreateLeadSheet();

  @override
  State<_CreateLeadSheet> createState() => _CreateLeadSheetState();
}

class _CreateLeadSheetState extends State<_CreateLeadSheet> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _contactController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _industrialSectorController = TextEditingController(
    text: 'Construccion',
  );
  final _creditStatusController = TextEditingController(text: 'Activo');
  final _projectStateController = TextEditingController();
  final _projectCityController = TextEditingController();
  final _requiredDeliveryTimeController = TextEditingController(
    text: '2-4 semanas',
  );
  final _mainCompetitorController = TextEditingController();
  final _sourceController = TextEditingController(text: 'Referido');
  final _amountController = TextEditingController();
  final _ownerController = TextEditingController(text: 'Erick Ramirez');
  final _notesController = TextEditingController();

  String _selectedStatus = 'Nuevo';
  DateTime _nextActionDate = DateTime.now().add(const Duration(days: 2));
  bool _createInitialTask = true;

  @override
  void dispose() {
    _companyController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _industrialSectorController.dispose();
    _creditStatusController.dispose();
    _projectStateController.dispose();
    _projectCityController.dispose();
    _requiredDeliveryTimeController.dispose();
    _mainCompetitorController.dispose();
    _sourceController.dispose();
    _amountController.dispose();
    _ownerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextActionDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );

    if (picked != null) {
      setState(() => _nextActionDate = picked);
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

    final input = CreateLeadInput(
      companyName: _companyController.text.trim(),
      contactName: _contactController.text.trim(),
      contactPhone: _phoneController.text.trim(),
      contactEmail: _emailController.text.trim(),
      industrialSector: _industrialSectorController.text.trim(),
      creditStatus: _creditStatusController.text.trim(),
      projectState: _projectStateController.text.trim(),
      projectCity: _projectCityController.text.trim(),
      projectLatitude: null,
      projectLongitude: null,
      requiredDeliveryTime: _requiredDeliveryTimeController.text.trim(),
      mainCompetitor: _mainCompetitorController.text.trim(),
      source: _sourceController.text.trim(),
      status: _selectedStatus,
      estimatedAmount: amount,
      nextActionDate: DateFormat('yyyy-MM-dd').format(_nextActionDate),
      owner: _ownerController.text.trim(),
      notes: _notesController.text.trim(),
    );

    Navigator.of(context).pop(
      _CreateLeadSheetResult(
        input: input,
        createInitialTask: _createInitialTask,
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
                'Nuevo prospecto',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Completa los datos para darlo de alta en el pipeline.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              _InputField(
                controller: _companyController,
                label: 'Empresa',
                hint: 'Ej. Hidraulica del Pacifico',
                validator: _requiredField,
              ),
              const SizedBox(height: 10),
              _InputField(
                controller: _contactController,
                label: 'Contacto',
                hint: 'Nombre de contacto',
                validator: _requiredField,
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _InputField(
                      controller: _industrialSectorController,
                      label: 'Giro industrial',
                      hint: 'Mineria, Energia, Construccion...',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InputField(
                      controller: _creditStatusController,
                      label: 'Estatus credito',
                      hint: 'Activo / Suspendido / En Tramite',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _InputField(
                      controller: _projectStateController,
                      label: 'Estado proyecto',
                      hint: 'Estado',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InputField(
                      controller: _projectCityController,
                      label: 'Ciudad proyecto',
                      hint: 'Ciudad',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _InputField(
                      controller: _requiredDeliveryTimeController,
                      label: 'Tiempo entrega',
                      hint: 'Inmediato / 2-4 semanas',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InputField(
                      controller: _mainCompetitorController,
                      label: 'Competidor principal',
                      hint: 'Contra quien se licita',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _InputField(
                      controller: _phoneController,
                      label: 'Telefono',
                      hint: '+52 ...',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InputField(
                      controller: _emailController,
                      label: 'Correo',
                      hint: 'contacto@empresa.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: _emailValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _InputField(
                      controller: _sourceController,
                      label: 'Origen',
                      hint: 'Referido',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedStatus,
                      decoration: const InputDecoration(labelText: 'Etapa'),
                      items: _leadStatusOptions
                          .map((status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          })
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedStatus = value);
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
                    child: _InputField(
                      controller: _amountController,
                      label: 'Monto estimado',
                      hint: '150000',
                      keyboardType: TextInputType.number,
                      validator: _requiredField,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Proxima accion',
                        ),
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(_nextActionDate),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _InputField(
                controller: _ownerController,
                label: 'Responsable',
                hint: 'Nombre del vendedor',
                validator: _requiredField,
              ),
              const SizedBox(height: 10),
              _InputField(
                controller: _notesController,
                label: 'Notas',
                hint: 'Comentarios clave del requerimiento',
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                value: _createInitialTask,
                contentPadding: EdgeInsets.zero,
                title: const Text('Crear tarea inicial de seguimiento'),
                activeThumbColor: AppColors.black,
                activeTrackColor: AppColors.yellow,
                onChanged: (value) {
                  setState(() => _createInitialTask = value);
                },
              ),
              const SizedBox(height: 8),
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
                      child: const Text('Guardar prospecto'),
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

class _UpdateLeadSheetResult {
  const _UpdateLeadSheetResult({required this.input});

  final UpdateLeadInput input;
}

class _UpdateLeadSheet extends StatefulWidget {
  const _UpdateLeadSheet({required this.lead});

  final Lead lead;

  @override
  State<_UpdateLeadSheet> createState() => _UpdateLeadSheetState();
}

class _UpdateLeadSheetState extends State<_UpdateLeadSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _companyController;
  late final TextEditingController _contactController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _industrialSectorController;
  late final TextEditingController _creditStatusController;
  late final TextEditingController _projectStateController;
  late final TextEditingController _projectCityController;
  late final TextEditingController _requiredDeliveryTimeController;
  late final TextEditingController _mainCompetitorController;
  late final TextEditingController _sourceController;
  late final TextEditingController _amountController;
  late final TextEditingController _ownerController;
  late final TextEditingController _notesController;

  late String _selectedStatus;
  late DateTime _nextActionDate;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController(text: widget.lead.companyName);
    _contactController = TextEditingController(
      text: widget.lead.contactName.isEmpty
          ? widget.lead.owner
          : widget.lead.contactName,
    );
    _phoneController = TextEditingController(text: widget.lead.contactPhone);
    _emailController = TextEditingController(text: widget.lead.contactEmail);
    _industrialSectorController = TextEditingController(
      text: widget.lead.industrialSector,
    );
    _creditStatusController = TextEditingController(
      text: widget.lead.creditStatus,
    );
    _projectStateController = TextEditingController(
      text: widget.lead.projectState,
    );
    _projectCityController = TextEditingController(
      text: widget.lead.projectCity,
    );
    _requiredDeliveryTimeController = TextEditingController(
      text: widget.lead.requiredDeliveryTime,
    );
    _mainCompetitorController = TextEditingController(
      text: widget.lead.mainCompetitor,
    );
    _sourceController = TextEditingController(text: widget.lead.source);
    _amountController = TextEditingController(
      text: widget.lead.estimatedAmount.toStringAsFixed(0),
    );
    _ownerController = TextEditingController(text: widget.lead.owner);
    _notesController = TextEditingController(text: widget.lead.notes);

    _selectedStatus = _leadStatusOptions.contains(widget.lead.status)
        ? widget.lead.status
        : 'Nuevo';
    _nextActionDate =
        DateTime.tryParse(widget.lead.nextActionDate) ??
        DateTime.now().add(const Duration(days: 2));
  }

  @override
  void dispose() {
    _companyController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _industrialSectorController.dispose();
    _creditStatusController.dispose();
    _projectStateController.dispose();
    _projectCityController.dispose();
    _requiredDeliveryTimeController.dispose();
    _mainCompetitorController.dispose();
    _sourceController.dispose();
    _amountController.dispose();
    _ownerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextActionDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );

    if (picked != null) {
      setState(() => _nextActionDate = picked);
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
      _UpdateLeadSheetResult(
        input: UpdateLeadInput(
          leadId: widget.lead.id,
          companyName: _companyController.text.trim(),
          contactName: _contactController.text.trim(),
          contactPhone: _phoneController.text.trim(),
          contactEmail: _emailController.text.trim(),
          industrialSector: _industrialSectorController.text.trim(),
          creditStatus: _creditStatusController.text.trim(),
          projectState: _projectStateController.text.trim(),
          projectCity: _projectCityController.text.trim(),
          projectLatitude: widget.lead.projectLatitude,
          projectLongitude: widget.lead.projectLongitude,
          requiredDeliveryTime: _requiredDeliveryTimeController.text.trim(),
          mainCompetitor: _mainCompetitorController.text.trim(),
          source: _sourceController.text.trim(),
          status: _selectedStatus,
          estimatedAmount: amount,
          nextActionDate: DateFormat('yyyy-MM-dd').format(_nextActionDate),
          owner: _ownerController.text.trim(),
          notes: _notesController.text.trim(),
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
                'Editar prospecto',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Actualiza datos y etapa del prospecto.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              _InputField(
                controller: _companyController,
                label: 'Empresa',
                hint: 'Ej. Hidraulica del Pacifico',
                validator: _requiredField,
              ),
              const SizedBox(height: 10),
              _InputField(
                controller: _contactController,
                label: 'Contacto',
                hint: 'Nombre de contacto',
                validator: _requiredField,
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _InputField(
                      controller: _industrialSectorController,
                      label: 'Giro industrial',
                      hint: 'Mineria, Energia, Construccion...',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InputField(
                      controller: _creditStatusController,
                      label: 'Estatus credito',
                      hint: 'Activo / Suspendido / En Tramite',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _InputField(
                      controller: _projectStateController,
                      label: 'Estado proyecto',
                      hint: 'Estado',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InputField(
                      controller: _projectCityController,
                      label: 'Ciudad proyecto',
                      hint: 'Ciudad',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _InputField(
                      controller: _requiredDeliveryTimeController,
                      label: 'Tiempo entrega',
                      hint: 'Inmediato / 2-4 semanas',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InputField(
                      controller: _mainCompetitorController,
                      label: 'Competidor principal',
                      hint: 'Contra quien se licita',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _InputField(
                      controller: _phoneController,
                      label: 'Telefono',
                      hint: '+52 ...',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _InputField(
                      controller: _emailController,
                      label: 'Correo',
                      hint: 'contacto@empresa.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: _emailValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _InputField(
                      controller: _sourceController,
                      label: 'Origen',
                      hint: 'Referido',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedStatus,
                      decoration: const InputDecoration(labelText: 'Etapa'),
                      items: _leadStatusOptions
                          .map((status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          })
                          .toList(growable: false),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedStatus = value);
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
                    child: _InputField(
                      controller: _amountController,
                      label: 'Monto estimado',
                      hint: '150000',
                      keyboardType: TextInputType.number,
                      validator: _requiredField,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Proxima accion',
                        ),
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(_nextActionDate),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _InputField(
                controller: _ownerController,
                label: 'Responsable',
                hint: 'Nombre del vendedor',
                validator: _requiredField,
              ),
              const SizedBox(height: 10),
              _InputField(
                controller: _notesController,
                label: 'Notas',
                hint: 'Comentarios clave del requerimiento',
                maxLines: 3,
              ),
              const SizedBox(height: 8),
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
                      child: const Text('Guardar cambios'),
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

class _LeadTaskSheetResult {
  const _LeadTaskSheetResult({
    required this.title,
    required this.type,
    required this.dueDate,
  });

  final String title;
  final String type;
  final String dueDate;
}

class _LeadTaskSheet extends StatefulWidget {
  const _LeadTaskSheet({required this.lead});

  final Lead lead;

  @override
  State<_LeadTaskSheet> createState() => _LeadTaskSheetState();
}

class _LeadTaskSheetState extends State<_LeadTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  String _selectedType = _taskTypeOptions.first;
  late DateTime _selectedDueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: 'Seguimiento lead ${widget.lead.companyName}',
    );
    _selectedDueDate =
        DateTime.tryParse(widget.lead.nextActionDate) ??
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
      _LeadTaskSheetResult(
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
                'Lead: ${widget.lead.companyName}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              _InputField(
                controller: _titleController,
                label: 'Titulo',
                hint: 'Seguimiento de especificaciones',
                validator: _requiredField,
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

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }
}

String? _requiredField(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Campo obligatorio';
  }
  return null;
}

String? _emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }
  if (!value.contains('@')) {
    return 'Correo invalido';
  }
  return null;
}

const _leadStatusOptions = <String>['Nuevo', 'Contactado', 'Calificado'];
const _taskTypeOptions = <String>[
  'Seguimiento',
  'Llamada',
  'Visita',
  'Cotizacion',
  'Correo',
];

UpdateLeadInput _leadToUpdateInput(Lead lead, {String? status}) {
  return UpdateLeadInput(
    leadId: lead.id,
    companyName: lead.companyName,
    contactName: lead.contactName.isEmpty ? lead.owner : lead.contactName,
    contactPhone: lead.contactPhone,
    contactEmail: lead.contactEmail,
    industrialSector: lead.industrialSector,
    creditStatus: lead.creditStatus,
    projectState: lead.projectState,
    projectCity: lead.projectCity,
    projectLatitude: lead.projectLatitude,
    projectLongitude: lead.projectLongitude,
    requiredDeliveryTime: lead.requiredDeliveryTime,
    mainCompetitor: lead.mainCompetitor,
    material: lead.material,
    schedule: lead.schedule,
    nominalDiameter: lead.nominalDiameter,
    endType: lead.endType,
    valveType: lead.valveType,
    pressureClass: lead.pressureClass,
    standard: lead.standard,
    lossReason: lead.lossReason,
    source: lead.source,
    status: status ?? lead.status,
    estimatedAmount: lead.estimatedAmount,
    nextActionDate: lead.nextActionDate,
    owner: lead.owner,
    notes: lead.notes,
  );
}

double _parseAmount(String raw) {
  final normalized = raw
      .replaceAll(RegExp(r'[^0-9\.\,]'), '')
      .replaceAll(',', '');
  return double.tryParse(normalized) ?? 0;
}
