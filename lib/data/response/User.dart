import 'package:aloha/data/response/contact.dart';
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

GetAllUserResponse getAllUserResponseFromJson(String str) =>
    GetAllUserResponse.fromJson(json.decode(str));

String getAllUserResponseToJson(GetAllUserResponse data) =>
    json.encode(data.toJson());

class GetAllUserResponse {
  GetAllUserResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  final bool success;
  final List<Agent> data;
  final String message;

  factory GetAllUserResponse.fromJson(Map<String, dynamic> json) =>
      GetAllUserResponse(
        success: json["success"],
        data: List<Agent>.from(json["data"].map((x) => Agent.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class UpdateUserResponse {
  UpdateUserResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  Agent data;
  String message;

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) =>
      UpdateUserResponse(
        success: json["success"],
        data: Agent.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}
