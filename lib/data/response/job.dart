import 'dart:convert';

import 'package:aloha/data/response/contact.dart';

List<Job> jobFromJson(String str) =>
    List<Job>.from(json.decode(str).map((x) => Job.fromJson(x)));

String jobToJson(List<Job> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JobResponse {
  JobResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  bool success;
  Job data;
  String message;

  factory JobResponse.fromJson(Map<String, dynamic> json) => JobResponse(
        success: json["success"],
        data: Job.fromJson(json['data']),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class Job {
  Job({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.agents,
  });

  final int id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Agent>? agents;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        agents: json['agents'] != null
            ? List<Agent>.from(
                json['agents'].map((element) => Agent.fromJson(element)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
