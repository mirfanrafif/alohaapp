class MessageTemplateResponse {
  MessageTemplateResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  final bool? success;
  final List<MessageTemplate> data;
  final String? message;

  factory MessageTemplateResponse.fromJson(Map<String, dynamic> json) {
    return MessageTemplateResponse(
      success: json["success"],
      data: json["data"] == null
          ? []
          : List<MessageTemplate>.from(
              json["data"]!.map((x) => MessageTemplate.fromJson(x))),
      message: json["message"],
    );
  }
}

class MessageTemplate {
  MessageTemplate({
    required this.id,
    required this.name,
    required this.template,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final String? name;
  final String? template;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory MessageTemplate.fromJson(Map<String, dynamic> json) {
    return MessageTemplate(
      id: json["id"],
      name: json["name"],
      template: json["template"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
    );
  }
}
