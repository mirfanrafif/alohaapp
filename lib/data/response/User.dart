// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'package:aloha/data/response/Contact.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

UserResponse userResponseFromJson(String str) =>
    UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
  UserResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  LoginData data;
  String message;

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        success: json["success"],
        data: LoginData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class LoginData {
  LoginData({
    required this.user,
    required this.token,
  });

  Agent user;
  String token;

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        user: Agent.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
      };
}
