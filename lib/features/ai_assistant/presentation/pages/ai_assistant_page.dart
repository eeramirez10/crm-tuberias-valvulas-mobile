import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_toast.dart';
import '../../../../core/design_system/crm_page_shell.dart';
import '../../domain/entities/ai_next_action.dart';
import '../providers/ai_assistant_providers.dart';

class AiAssistantPage extends ConsumerStatefulWidget {
  const AiAssistantPage({super.key});

  @override
  ConsumerState<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends ConsumerState<AiAssistantPage> {
  final _customerController = TextEditingController(
    text: 'Constructora del Golfo',
  );
  final _contextController = TextEditingController(
    text: 'Seguimiento de cotizacion de tuberia c40 y valvulas de compuerta.',
  );
  String _channel = 'whatsapp';

  @override
  void dispose() {
    _customerController.dispose();
    _contextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiAssistantControllerProvider);

    return CrmPageShell(
      title: 'Asistente IA',
      subtitle: 'Copiloto comercial simulado',
      actions: <Widget>[
        ActionSquare(
          icon: Icons.auto_graph_rounded,
          onTap: () async {
            try {
              await ref
                  .read(aiAssistantControllerProvider.notifier)
                  .refreshSmartActions();
              if (context.mounted) {
                AppToast.info(context, 'Recomendaciones actualizadas.');
              }
            } catch (_) {
              if (context.mounted) {
                AppToast.info(
                  context,
                  'No se pudieron actualizar recomendaciones.',
                );
              }
            }
          },
        ),
        const SizedBox(width: 8),
        ActionSquare(icon: Icons.tune_rounded, onTap: () {}),
      ],
      child: state.when(
        data: (viewModel) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Insights de hoy',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ...viewModel.insights.map(
                        (item) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.yellow,
                            child: Icon(
                              Icons.flash_on,
                              color: AppColors.black,
                              size: 18,
                            ),
                          ),
                          title: Text(item.title),
                          subtitle: Text(item.detail),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.yellow,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              item.priority,
                              style: const TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _NextActionsCard(
                actions: viewModel.nextActions,
                isApplying: viewModel.isApplying,
                onApply: (action) async {
                  try {
                    await ref
                        .read(aiAssistantControllerProvider.notifier)
                        .applyRecommendation(action);
                    if (context.mounted) {
                      AppToast.success(
                        context,
                        'Recomendacion aplicada. Tarea y actividad registradas.',
                      );
                    }
                  } catch (_) {
                    if (context.mounted) {
                      AppToast.info(
                        context,
                        'No se pudo aplicar la recomendacion IA.',
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _customerController,
                        decoration: const InputDecoration(labelText: 'Cliente'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _contextController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Contexto de seguimiento',
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _channel,
                        decoration: const InputDecoration(labelText: 'Canal'),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                            value: 'whatsapp',
                            child: Text('WhatsApp'),
                          ),
                          DropdownMenuItem(
                            value: 'correo',
                            child: Text('Correo'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _channel = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.black,
                            foregroundColor: AppColors.yellow,
                          ),
                          onPressed: viewModel.isGeneratingDraft
                              ? null
                              : () async {
                                  try {
                                    await ref
                                        .read(
                                          aiAssistantControllerProvider
                                              .notifier,
                                        )
                                        .generateDraft(
                                          customerName:
                                              _customerController.text,
                                          context: _contextController.text,
                                          channel: _channel,
                                        );
                                    if (context.mounted) {
                                      AppToast.success(
                                        context,
                                        'Borrador generado con exito.',
                                      );
                                    }
                                  } catch (_) {
                                    if (context.mounted) {
                                      AppToast.info(
                                        context,
                                        'No se pudo generar el borrador.',
                                      );
                                    }
                                  }
                                },
                          icon: const Icon(Icons.auto_fix_high),
                          label: Text(
                            viewModel.isGeneratingDraft
                                ? 'Generando...'
                                : 'Generar borrador',
                          ),
                        ),
                      ),
                      if (viewModel.lastDraft != null) ...<Widget>[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Asunto sugerido: ${viewModel.lastDraft!.suggestedSubject}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.panelBorder),
                          ),
                          child: Text(viewModel.lastDraft!.draft),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error en IA: $error')),
      ),
    );
  }
}

class _NextActionsCard extends StatelessWidget {
  const _NextActionsCard({
    required this.actions,
    required this.isApplying,
    required this.onApply,
  });

  final List<AiNextAction> actions;
  final bool Function(String actionId) isApplying;
  final Future<void> Function(AiNextAction action) onApply;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Top 5 siguientes acciones',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (actions.isEmpty)
              const Text('No hay recomendaciones pendientes.')
            else
              ...actions.map(
                (action) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ActionTile(
                    action: action,
                    applying: isApplying(action.id),
                    onApply: () => onApply(action),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.action,
    required this.applying,
    required this.onApply,
  });

  final AiNextAction action;
  final bool applying;
  final Future<void> Function() onApply;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.panelBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  action.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _PriorityChip(priority: action.priority),
            ],
          ),
          const SizedBox(height: 6),
          Text(action.reason, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            'Tarea sugerida: ${action.suggestedTaskTitle} (${action.suggestedDueDate})',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: applying ? null : onApply,
              icon: applying
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_fix_high),
              label: Text(applying ? 'Aplicando...' : 'Aplicar recomendacion'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    final normalized = priority.toLowerCase();
    final background = switch (normalized) {
      'alta' => Colors.red.shade100,
      'media' => AppColors.yellowSoft,
      _ => Colors.green.shade100,
    };
    final foreground = switch (normalized) {
      'alta' => Colors.red.shade900,
      'media' => AppColors.black,
      _ => Colors.green.shade900,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        priority,
        style: TextStyle(color: foreground, fontWeight: FontWeight.w700),
      ),
    );
  }
}
