import 'contact.dart';

class StartConversationResponse {
  StartConversationResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  final bool? success;
  final Data? data;
  final String? message;

  factory StartConversationResponse.fromJson(Map<String, dynamic> json) {
    return StartConversationResponse(
      success: json["success"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      message: json["message"],
    );
  }
}

class Data {
  Data({
    required this.customer,
    required this.agent,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
  });

  final Customer? customer;
  final User? agent;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? id;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      customer:
          json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      agent: json["agent"] == null ? null : User.fromJson(json["agent"]),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      id: json["id"],
    );
  }
}
