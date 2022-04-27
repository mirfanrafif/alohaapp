import 'dart:convert';

import 'contact.dart';

MessageResponse messageResponseFromJson(String str) =>
    MessageResponse.fromJson(json.decode(str));

String messageResponseToJson(MessageResponse data) =>
    json.encode(data.toJson());

class MessageResponse {
  MessageResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  List<MessageEntity> data;
  String message;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      MessageResponse(
        success: json["success"],
        data: List<MessageEntity>.from(json["data"].map((x) => MessageEntity.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

MessageEntity messageFromJson(String str) => MessageEntity.fromJson(json.decode(str));

String messageToJson(MessageEntity data) => json.encode(data.toJson());

class MessageEntity {
  MessageEntity({
    required this.id,
    required this.customer,
    required this.fromMe,
    required this.file,
    required this.message,
    required this.agent,
    required this.senderName,
    required this.messageId,
    required this.status,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  Customer customer;
  bool fromMe;
  String? file;
  String message;
  User? agent;
  String? senderName;
  String messageId;
  String status;
  String type;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory MessageEntity.fromJson(Map<String, dynamic> json) => MessageEntity(
        id: json["id"],
        customer: Customer.fromJson(json["customer"]),
        fromMe: json["fromMe"],
        file: json["file"],
        message: json["message"],
        agent: json['agent'] != null ? User.fromJson(json["agent"]) : null,
        senderName: json["sender_name"],
        messageId: json["messageId"],
        status: json["status"],
        type: json["type"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer": customer.toJson(),
        "fromMe": fromMe,
        "file": file,
        "message": message,
        "agent": agent?.toJson(),
        "sender_name": senderName,
        "messageId": messageId,
        "status": status,
        "type": type,
        "created_at": createdAt != null ? createdAt!.toIso8601String() : null,
        "updated_at": updatedAt != null ? updatedAt!.toIso8601String() : null,
      };
}
