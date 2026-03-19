import '../../domain/entities/customer.dart';
import '../../domain/repositories/customers_repository.dart';
import '../datasources/customers_datasource.dart';
import '../dtos/get_customers_request_dto.dart';

class CustomersRepositoryImpl implements CustomersRepository {
  const CustomersRepositoryImpl(this._datasource);

  final CustomersDatasource _datasource;

  @override
  Future<List<Customer>> getCustomers({String? query}) async {
    final dto = await _datasource.getCustomers(
      GetCustomersRequestDto(query: query),
    );
    return dto.items.map((item) => item.toEntity()).toList(growable: false);
  }
}
