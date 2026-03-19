import '../../domain/entities/lead.dart';
import '../../domain/repositories/leads_repository.dart';
import '../datasources/leads_datasource.dart';
import '../dtos/get_leads_request_dto.dart';

class LeadsRepositoryImpl implements LeadsRepository {
  const LeadsRepositoryImpl(this._datasource);

  final LeadsDatasource _datasource;

  @override
  Future<List<Lead>> getLeads({String? status}) async {
    final dto = await _datasource.getLeads(GetLeadsRequestDto(status: status));
    return dto.items.map((item) => item.toEntity()).toList(growable: false);
  }
}
