class ApiResponse<T> {
  Status status;

  T? data;

  String? message;

  ErrorStatus? errorStatus;

  ApiResponse.loading(this.message) : status = Status.LOADING;

  ApiResponse.completed(this.data) : status = Status.COMPLETED;

  ApiResponse.error(this.message, this.data, this.errorStatus)
      : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }

enum ErrorStatus {
  unauthorized,
  noInternet,
  serverError,
  somethingWentWrong,
}
