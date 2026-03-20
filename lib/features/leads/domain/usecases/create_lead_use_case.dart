import '../entities/create_lead_input.dart';
import '../entities/lead.dart';
import '../repositories/leads_repository.dart';

class CreateLeadUseCase {
  const CreateLeadUseCase(this._repository);

  final LeadsRepository _repository;

  Future<Lead> call(CreateLeadInput input) {
    return _repository.createLead(input);
  }
}
