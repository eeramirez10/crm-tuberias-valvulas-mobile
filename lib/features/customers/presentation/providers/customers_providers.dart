import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/core_providers.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customers_repository.dart';
import '../../domain/usecases/get_customers_use_case.dart';
import '../../infrastructure/datasources/customers_datasource.dart';
import '../../infrastructure/repositories/customers_repository_impl.dart';

part 'customers_providers.g.dart';

@riverpod
CustomersDatasource customersDatasource(Ref ref) {
  return CustomersDatasource(ref.watch(httpAdapterProvider));
}

@riverpod
CustomersRepository customersRepository(Ref ref) {
  return CustomersRepositoryImpl(ref.watch(customersDatasourceProvider));
}

@riverpod
GetCustomersUseCase getCustomersUseCase(Ref ref) {
  return GetCustomersUseCase(ref.watch(customersRepositoryProvider));
}

@riverpod
Future<List<Customer>> customers(Ref ref, {String? query}) {
  return ref.watch(getCustomersUseCaseProvider).call(query: query);
}
