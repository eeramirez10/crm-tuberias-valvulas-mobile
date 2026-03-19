import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return SafeArea(
      child: state.when(
        data: (viewModel) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text(
                'Asistente IA (simulado)',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Los endpoints y contratos ya estan listos para backend real.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Insights de hoy',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...viewModel.insights.map(
                        (item) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Text(item.title),
                          subtitle: Text(item.detail),
                          trailing: Chip(label: Text(item.priority)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _customerController,
                        decoration: const InputDecoration(
                          labelText: 'Cliente',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _contextController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Contexto de seguimiento',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: _channel,
                        decoration: const InputDecoration(
                          labelText: 'Canal',
                          border: OutlineInputBorder(),
                        ),
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
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Text(viewModel.lastDraft!.draft),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error en IA: $error')),
      ),
    );
  }
}
