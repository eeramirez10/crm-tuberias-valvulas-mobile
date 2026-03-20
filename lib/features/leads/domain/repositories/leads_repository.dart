import '../entities/create_lead_input.dart';
import '../entities/lead.dart';
import '../entities/update_lead_input.dart';

abstract class LeadsRepository {
  Future<List<Lead>> getLeads({String? status});
  Future<Lead> createLead(CreateLeadInput input);
  Future<Lead> updateLead(UpdateLeadInput input);
}
