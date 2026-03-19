import '../entities/customer.dart';
import '../repositories/customers_repository.dart';

class GetCustomersUseCase {
  const GetCustomersUseCase(this._repository);

  final CustomersRepository _repository;

  Future<List<Customer>> call({String? query}) {
    return _repository.getCustomers(query: query);
  }
}
