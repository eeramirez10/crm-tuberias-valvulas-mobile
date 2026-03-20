import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/design_system/app_toast.dart';
import '../../../../core/design_system/crm_page_shell.dart';
import '../../../tasks/domain/entities/task_item.dart';
import '../../../tasks/presentation/providers/tasks_providers.dart';
import '../providers/activities_providers.dart';

class CommercialHistoryPage extends ConsumerWidget {
  const CommercialHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(tasksControllerProvider);
    final activitiesState = ref.watch(activitiesTimelineControllerProvider);

    return CrmPageShell(
      title: 'Seguimiento',
      subtitle: 'Tareas y historial comercial',
      actions: <Widget>[
        ActionSquare(
          icon: Icons.add_comment_outlined,
          onTap: () async {
            try {
              await ref
                  .read(activitiesTimelineControllerProvider.notifier)
                  .logInteraction(
                    type: 'Nota',
                    summary:
                        'Registro rapido: seguimiento comercial actualizado.',
                  );
              if (context.mounted) {
                AppToast.success(context, 'Actividad agregada al historial.');
              }
            } catch (_) {
              if (context.mounted) {
                AppToast.info(context, 'No se pudo registrar actividad.');
              }
            }
          },
        ),
        const SizedBox(width: 8),
        ActionSquare(
          icon: Icons.refresh_rounded,
          onTap: () {
            ref.invalidate(tasksControllerProvider);
            ref.invalidate(activitiesTimelineControllerProvider);
          },
        ),
      ],
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(tasksControllerProvider);
          ref.invalidate(activitiesTimelineControllerProvider);
        },
        child: ListView(
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
                      'Tareas de seguimiento',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    tasksState.when(
                      data: (items) => _TasksList(items: items),
                      loading: () => const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (_, _) => const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('No se pudieron cargar tareas.'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Historial comercial',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    activitiesState.when(
                      data: (items) {
                        if (items.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('No hay actividades registradas.'),
                          );
                        }

                        return Column(
                          children: items
                              .take(10)
                              .map(
                                (activity) => ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: const Icon(Icons.history),
                                  title: Text(activity.summary),
                                  subtitle: Text(
                                    '${activity.type} • ${activity.owner}',
                                  ),
                                  trailing: Text(
                                    DateFormat(
                                      'dd/MM HH:mm',
                                    ).format(activity.createdAt),
                                  ),
                                ),
                              )
                              .toList(growable: false),
                        );
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.all(12),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (_, _) => const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('No se pudo cargar historial.'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _TasksList extends ConsumerWidget {
  const _TasksList({required this.items});

  final List<TaskItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: Text('No hay tareas pendientes.'),
      );
    }

    return Column(
      children: items
          .take(6)
          .map(
            (task) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(task.title),
              subtitle: Text('${task.type} • ${task.dueDate}'),
              trailing: FilledButton.tonalIcon(
                onPressed: () async {
                  try {
                    await ref
                        .read(tasksControllerProvider.notifier)
                        .complete(task.id);
                    await ref
                        .read(activitiesTimelineControllerProvider.notifier)
                        .logInteraction(
                          type: 'Tarea',
                          summary: 'Tarea completada: ${task.title}',
                        );
                    if (context.mounted) {
                      AppToast.success(context, 'Tarea marcada como hecha.');
                    }
                  } catch (_) {
                    if (context.mounted) {
                      AppToast.info(context, 'No se pudo completar tarea.');
                    }
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Hecha'),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}
