import '../../domain/entities/create_lead_input.dart';
import '../../domain/entities/lead.dart';
import '../../domain/repositories/leads_repository.dart';
import '../datasources/leads_datasource.dart';
import '../dtos/create_lead_request_dto.dart';
import '../dtos/get_leads_request_dto.dart';

class LeadsRepositoryImpl implements LeadsRepository {
  const LeadsRepositoryImpl(this._datasource);

  final LeadsDatasource _datasource;

  @override
  Future<List<Lead>> getLeads({String? status}) async {
    final dto = await _datasource.getLeads(GetLeadsRequestDto(status: status));
    return dto.items.map((item) => item.toEntity()).toList(growable: false);
  }

  @override
  Future<Lead> createLead(CreateLeadInput input) async {
    final response = await _datasource.createLead(
      CreateLeadRequestDto.fromInput(input),
    );
    if (!response.ok) {
      throw StateError(response.message ?? 'No se pudo crear el prospecto.');
    }
    return response.toEntity();
  }
}
