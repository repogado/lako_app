class APIResponse<T> {
  String msg = '';
  bool success = false;
  T? data;

  APIResponse(
    this.msg,
    this.success,
    this.data,
  );

  APIResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    success = json['success'];
    data = json['data'];
  }
}
