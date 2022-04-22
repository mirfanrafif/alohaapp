import 'dart:convert';

import 'package:aloha/data/response/customer_categories.dart';
import 'package:aloha/data/response/message.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:aloha/utils/constants.dart';
import 'package:http/http.dart';

class BroadcastMessageService {
  Future<ApiResponse<List<CustomerCategories>?>> getCustomerCategories(
      String token) async {
    try {
      var response = await get(Uri.https(baseUrl, '/customer/categories'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode < 400) {
        var responseData =
            CustomerCategoriesResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true,
            data: responseData.data,
            message: 'Success get customer categories');
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

  Future<ApiResponse<List<CustomerInterests>?>> getCustomerInterests(
      String token) async {
    try {
      var response = await get(Uri.https(baseUrl, '/customer/interests'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode < 400) {
        var responseData =
            CustomerInterestsResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true,
            data: responseData.data,
            message: 'Success get customer categories');
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

  Future<ApiResponse<List<CustomerTypes>?>> getCustomerTypes(
      String token) async {
    try {
      var response = await get(Uri.https(baseUrl, '/customer/types'),
          headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode < 400) {
        var responseData =
            CustomerTypesResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true,
            data: responseData.data,
            message: 'Success get customer categories');
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

  Future<ApiResponse<List<Message>?>> sendBroadcastMessage(
      {required List<String> categories,
      required List<String> types,
      required List<String> interests,
      required String message,
      required String token}) async {
    try {
      var request = jsonEncode({
        'message': message,
        'categories': categories,
        'interests': interests,
        'types': types
      });

      var response = await post(Uri.https(baseUrl, "/message/broadcast"),
          body: request,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });
      if (response.statusCode < 400) {
        var data = messageResponseFromJson(response.body);
        return ApiResponse(
            success: true, data: data.data, message: data.message);
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
