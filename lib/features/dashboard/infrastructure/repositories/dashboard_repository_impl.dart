import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._datasource);

  final DashboardDatasource _datasource;

  @override
  Future<DashboardSummary> getSummary() async {
    final dto = await _datasource.getSummary();
    return dto.toEntity();
  }
}
