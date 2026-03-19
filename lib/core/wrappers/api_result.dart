import 'failure.dart';

sealed class ApiResult<T> {
  const ApiResult();

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    final current = this;
    if (current is ApiSuccess<T>) {
      return success(current.data);
    }
    return failure((current as ApiFailure<T>).error);
  }
}

class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);

  final T data;
}

class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.error);

  final Failure error;
}
