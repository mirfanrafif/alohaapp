class ApiResponse<T> {
  bool success;
  T? data;
  String message;

  ApiResponse(
      {required this.success, required this.data, required this.message});
}
