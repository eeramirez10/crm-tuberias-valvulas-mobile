import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../activities/domain/entities/create_activity_input.dart';
import '../../../activities/presentation/providers/activities_providers.dart';
import '../../../tasks/domain/entities/create_task_input.dart';
import '../../../tasks/presentation/providers/tasks_providers.dart';
import '../../domain/entities/ai_insight.dart';
import '../../domain/entities/ai_next_action.dart';
import '../../domain/entities/ai_risk_summary.dart';
import '../../domain/entities/follow_up_draft.dart';
import '../../domain/repositories/ai_assistant_repository.dart';
import '../../domain/usecases/generate_follow_up_draft_use_case.dart';
import '../../domain/usecases/get_ai_insights_use_case.dart';
import '../../domain/usecases/get_ai_next_actions_use_case.dart';
import '../../domain/usecases/get_ai_risk_summary_use_case.dart';
import '../../infrastructure/datasources/ai_assistant_datasource.dart';
import '../../infrastructure/repositories/ai_assistant_repository_impl.dart';

part 'ai_assistant_providers.g.dart';

class AiAssistantViewModel {
  const AiAssistantViewModel({
    required this.insights,
    required this.nextActions,
    this.lastDraft,
    this.isGeneratingDraft = false,
    this.applyingActionId,
  });

  final List<AiInsight> insights;
  final List<AiNextAction> nextActions;
  final FollowUpDraft? lastDraft;
  final bool isGeneratingDraft;
  final String? applyingActionId;

  bool isApplying(String actionId) => applyingActionId == actionId;

  AiAssistantViewModel copyWith({
    List<AiInsight>? insights,
    List<AiNextAction>? nextActions,
    FollowUpDraft? lastDraft,
    bool? isGeneratingDraft,
    String? applyingActionId,
    bool clearDraft = false,
    bool clearApplying = false,
  }) {
    return AiAssistantViewModel(
      insights: insights ?? this.insights,
      nextActions: nextActions ?? this.nextActions,
      lastDraft: clearDraft ? null : (lastDraft ?? this.lastDraft),
      isGeneratingDraft: isGeneratingDraft ?? this.isGeneratingDraft,
      applyingActionId: clearApplying
          ? null
          : (applyingActionId ?? this.applyingActionId),
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
GetAiNextActionsUseCase getAiNextActionsUseCase(Ref ref) {
  return GetAiNextActionsUseCase(ref.watch(aiAssistantRepositoryProvider));
}

@riverpod
GetAiRiskSummaryUseCase getAiRiskSummaryUseCase(Ref ref) {
  return GetAiRiskSummaryUseCase(ref.watch(aiAssistantRepositoryProvider));
}

@riverpod
GenerateFollowUpDraftUseCase generateFollowUpDraftUseCase(Ref ref) {
  return GenerateFollowUpDraftUseCase(ref.watch(aiAssistantRepositoryProvider));
}

@riverpod
Future<AiRiskSummary> aiRiskSummary(Ref ref) {
  return ref.watch(getAiRiskSummaryUseCaseProvider).call();
}

@riverpod
class AiAssistantController extends _$AiAssistantController {
  @override
  Future<AiAssistantViewModel> build() async {
    final insights = await ref.watch(getAiInsightsUseCaseProvider).call();
    final nextActions = await ref.watch(getAiNextActionsUseCaseProvider).call();

    return AiAssistantViewModel(insights: insights, nextActions: nextActions);
  }

  Future<void> refreshSmartActions() async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    state = const AsyncLoading();
    final nextActions = await ref.read(getAiNextActionsUseCaseProvider).call();
    state = AsyncData(current.copyWith(nextActions: nextActions));
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

      final latest = state.valueOrNull ?? current;
      state = AsyncData(
        latest.copyWith(lastDraft: draft, isGeneratingDraft: false),
      );
    } catch (error, stackTrace) {
      final latest = state.valueOrNull ?? current;
      state = AsyncData(latest.copyWith(isGeneratingDraft: false));
      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> applyRecommendation(AiNextAction action) async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }

    final beforeApply = state.valueOrNull ?? current;
    state = AsyncData(beforeApply.copyWith(applyingActionId: action.id));

    try {
      await ref
          .read(createTaskUseCaseProvider)
          .call(
            CreateTaskInput(
              title: action.suggestedTaskTitle,
              type: action.suggestedTaskType,
              dueDate: action.suggestedDueDate,
              relatedTo: action.targetId,
            ),
          );

      await ref
          .read(createActivityUseCaseProvider)
          .call(
            CreateActivityInput(
              type: 'IA',
              summary:
                  'Se aplico recomendacion IA: ${action.title}. Tarea: ${action.suggestedTaskTitle}.',
              owner: 'Erick Ramirez',
            ),
          );

      final refreshedActions = await ref
          .read(getAiNextActionsUseCaseProvider)
          .call();
      final filtered = refreshedActions
          .where((item) => item.id != action.id)
          .toList(growable: false);

      final latest = state.valueOrNull ?? beforeApply;
      state = AsyncData(
        latest.copyWith(nextActions: filtered, clearApplying: true),
      );

      ref.invalidate(tasksControllerProvider);
      ref.invalidate(activitiesTimelineControllerProvider);
      ref.invalidate(aiRiskSummaryProvider);
    } catch (error, stackTrace) {
      final latest = state.valueOrNull ?? beforeApply;
      state = AsyncData(latest.copyWith(clearApplying: true));
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}
