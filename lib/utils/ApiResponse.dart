import 'dart:convert';

class ApiResponse<T> {
  bool success;
  T? data;
  String message;

  ApiResponse(
      {required this.success, required this.data, required this.message});
}


ApiErrorResponse apiErrorResponseFromJson(String str) => ApiErrorResponse.fromJson(jsonDecode(str));

String apiErrorResponseToJson(ApiErrorResponse data) => json.encode(data.toJson());

class ApiErrorResponse {
  ApiErrorResponse({
    required this.message,
  });
  String message;

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) => ApiErrorResponse(
    message: json["message"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
