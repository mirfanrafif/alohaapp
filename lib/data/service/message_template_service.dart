import 'dart:convert';

import 'package:aloha/data/response/message_template.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:aloha/utils/constants.dart';
import 'package:http/http.dart';

class MessageTemplateService {
  Future<ApiResponse<List<MessageTemplate>>> getTemplates() async {
    try {
      var response = await get(
        Uri.https(baseUrl, '/message-template'),
      );

      if (response.statusCode < 400) {
        var data = MessageTemplateResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true, data: data.data, message: data.message ?? "");
      } else {
        var errorResponse =
            ApiErrorResponse.fromJson(jsonDecode(response.body));
        print(errorResponse.message);
        return ApiResponse(
            success: false, data: [], message: errorResponse.message);
      }
    } catch (e) {
      print(e.toString());
      return ApiResponse(success: false, data: [], message: e.toString());
    }
  }
}
