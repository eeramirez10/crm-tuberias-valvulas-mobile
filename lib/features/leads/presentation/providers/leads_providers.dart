import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/lead.dart';
import '../../domain/repositories/leads_repository.dart';
import '../../domain/usecases/create_lead_use_case.dart';
import '../../domain/usecases/get_leads_use_case.dart';
import '../../domain/usecases/update_lead_use_case.dart';
import '../../infrastructure/datasources/leads_datasource.dart';
import '../../infrastructure/repositories/leads_repository_impl.dart';

part 'leads_providers.g.dart';

@riverpod
LeadsDatasource leadsDatasource(Ref ref) {
  return LeadsDatasource(ref.watch(httpAdapterProvider));
}

@riverpod
LeadsRepository leadsRepository(Ref ref) {
  return LeadsRepositoryImpl(ref.watch(leadsDatasourceProvider));
}

@riverpod
GetLeadsUseCase getLeadsUseCase(Ref ref) {
  return GetLeadsUseCase(ref.watch(leadsRepositoryProvider));
}

@riverpod
CreateLeadUseCase createLeadUseCase(Ref ref) {
  return CreateLeadUseCase(ref.watch(leadsRepositoryProvider));
}

@riverpod
UpdateLeadUseCase updateLeadUseCase(Ref ref) {
  return UpdateLeadUseCase(ref.watch(leadsRepositoryProvider));
}

@riverpod
Future<List<Lead>> leads(Ref ref, {String? status}) {
  return ref.watch(getLeadsUseCaseProvider).call(status: status);
}
