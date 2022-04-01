import 'dart:convert';

import 'Contact.dart';

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
  List<Message> data;
  String message;

  factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      MessageResponse(
        success: json["success"],
        data: List<Message>.from(json["data"].map((x) => Message.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
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
  Agent? agent;
  String senderName;
  String messageId;
  String status;
  String type;
  DateTime createdAt;
  DateTime updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        customer: Customer.fromJson(json["customer"]),
        fromMe: json["fromMe"],
        file: json["file"],
        message: json["message"],
        agent: json['agent'] != null ? Agent.fromJson(json["agent"]) : null,
        senderName: json["sender_name"],
        messageId: json["messageId"],
        status: json["status"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
