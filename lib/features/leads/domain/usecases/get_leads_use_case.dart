import '../entities/lead.dart';
import '../repositories/leads_repository.dart';

class GetLeadsUseCase {
  const GetLeadsUseCase(this._repository);

  final LeadsRepository _repository;

  Future<List<Lead>> call({String? status}) {
    return _repository.getLeads(status: status);
  }
}
