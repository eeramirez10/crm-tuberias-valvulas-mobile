import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/ai_insight.dart';
import '../../domain/entities/follow_up_draft.dart';
import '../../domain/repositories/ai_assistant_repository.dart';
import '../../domain/usecases/generate_follow_up_draft_use_case.dart';
import '../../domain/usecases/get_ai_insights_use_case.dart';
import '../../infrastructure/datasources/ai_assistant_datasource.dart';
import '../../infrastructure/repositories/ai_assistant_repository_impl.dart';

part 'ai_assistant_providers.g.dart';

class AiAssistantViewModel {
  const AiAssistantViewModel({
    required this.insights,
    this.lastDraft,
    this.isGeneratingDraft = false,
  });

  final List<AiInsight> insights;
  final FollowUpDraft? lastDraft;
  final bool isGeneratingDraft;

  AiAssistantViewModel copyWith({
    List<AiInsight>? insights,
    FollowUpDraft? lastDraft,
    bool? isGeneratingDraft,
    bool clearDraft = false,
  }) {
    return AiAssistantViewModel(
      insights: insights ?? this.insights,
      lastDraft: clearDraft ? null : (lastDraft ?? this.lastDraft),
      isGeneratingDraft: isGeneratingDraft ?? this.isGeneratingDraft,
    );
  }
}

@riverpod
AiAssistantDatasource aiAssistantDatasource(Ref ref) {
  return AiAssistantDatasource(ref.watch(httpAdapterProvider));
}

@riverpod
AiAssistantRepository aiAssistantRepository(Ref ref) {
  return AiAssistantRepositoryImpl(ref.watch(aiAssistantDatasourceProvider));
}

@riverpod
GetAiInsightsUseCase getAiInsightsUseCase(Ref ref) {
  return GetAiInsightsUseCase(ref.watch(aiAssistantRepositoryProvider));
}

@riverpod
GenerateFollowUpDraftUseCase generateFollowUpDraftUseCase(Ref ref) {
  return GenerateFollowUpDraftUseCase(ref.watch(aiAssistantRepositoryProvider));
}

@riverpod
class AiAssistantController extends _$AiAssistantController {
  @override
  Future<AiAssistantViewModel> build() async {
    final insights = await ref.watch(getAiInsightsUseCaseProvider).call();
    return AiAssistantViewModel(insights: insights);
  }

  Future<void> generateDraft({
    required String customerName,
    required String context,
    required String channel,
  }) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    state = AsyncData(current.copyWith(isGeneratingDraft: true));

    try {
      final draft = await ref
          .read(generateFollowUpDraftUseCaseProvider)
          .call(customerName: customerName, context: context, channel: channel);

      state = AsyncData(
        current.copyWith(lastDraft: draft, isGeneratingDraft: false),
      );
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}
