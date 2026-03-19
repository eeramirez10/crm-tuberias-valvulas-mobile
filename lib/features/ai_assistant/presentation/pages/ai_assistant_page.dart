import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/crm_page_shell.dart';
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
        ActionSquare(icon: Icons.auto_graph_rounded, onTap: () {}),
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
                                  await ref
                                      .read(
                                        aiAssistantControllerProvider.notifier,
                                      )
                                      .generateDraft(
                                        customerName: _customerController.text,
                                        context: _contextController.text,
                                        channel: _channel,
                                      );
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
