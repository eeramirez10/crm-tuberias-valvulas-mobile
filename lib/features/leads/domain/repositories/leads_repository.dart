import '../entities/lead.dart';

abstract class LeadsRepository {
  Future<List<Lead>> getLeads({String? status});
}
