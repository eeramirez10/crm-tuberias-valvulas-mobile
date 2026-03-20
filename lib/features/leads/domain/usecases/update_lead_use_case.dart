import '../entities/lead.dart';
import '../entities/update_lead_input.dart';
import '../repositories/leads_repository.dart';

class UpdateLeadUseCase {
  const UpdateLeadUseCase(this._repository);

  final LeadsRepository _repository;

  Future<Lead> call(UpdateLeadInput input) {
    return _repository.updateLead(input);
  }
}
