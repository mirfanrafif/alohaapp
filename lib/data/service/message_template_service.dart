import 'dart:convert';

import 'package:aloha/data/response/message_template.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:aloha/utils/constants.dart';
import 'package:http/http.dart';

class MessageTemplateService {
  Future<ApiResponse<List<MessageTemplate>>> getTemplates(String token) async {
    try {
      var response = await get(Uri.https(baseUrl, '/message-template'),
          headers: {'Authorization': 'Bearer ' + token});

      if (response.statusCode < 400) {
        var data = MessageTemplateResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true, data: data.data, message: data.message ?? "");
      } else {
        var errorResponse =
            ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false, data: [], message: errorResponse.message);
      }
    } catch (e) {
      return ApiResponse(success: false, data: [], message: e.toString());
    }
  }

  Future<ApiResponse<MessageTemplate?>> addTemplate(
      String nama, String template, String token) async {
    try {
      var request = {'name': nama, 'template': template};
      var response = await post(Uri.https(baseUrl, '/message-template'),
          headers: {'Authorization': 'Bearer ' + token}, body: request);

      if (response.statusCode < 400) {
        var responseData = jsonDecode(response.body)['data'];
        var data = MessageTemplate.fromJson(responseData);
        return ApiResponse(success: true, data: data, message: "");
      } else {
        var errorResponse =
            ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false, data: null, message: errorResponse.message);
      }
    } catch (e) {
      return ApiResponse(success: false, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<MessageTemplate?>> editTemplate(
      int id, String nama, String template, String token) async {
    try {
      var request = {'name': nama, 'template': template};
      var response = await put(Uri.https(baseUrl, '/message-template/$id'),
          headers: {'Authorization': 'Bearer ' + token}, body: request);

      if (response.statusCode < 400) {
        var responseData = jsonDecode(response.body)['data'];
        var data = MessageTemplate.fromJson(responseData);
        return ApiResponse(success: true, data: data, message: "");
      } else {
        var errorResponse =
            ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false, data: null, message: errorResponse.message);
      }
    } catch (e) {
      return ApiResponse(success: false, data: null, message: e.toString());
    }
  }

  Future<ApiResponse<MessageTemplate?>> deleteTemplate(
      int id, String token) async {
    try {
      var response = await delete(Uri.https(baseUrl, '/message-template/$id'),
          headers: {'Authorization': 'Bearer ' + token});

      if (response.statusCode < 400) {
        var responseData = jsonDecode(response.body)['data'];
        var data = MessageTemplate.fromJson(responseData);
        return ApiResponse(success: true, data: data, message: "");
      } else {
        var errorResponse =
            ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false, data: null, message: errorResponse.message);
      }
    } catch (e) {
      return ApiResponse(success: false, data: null, message: e.toString());
    }
  }
}
