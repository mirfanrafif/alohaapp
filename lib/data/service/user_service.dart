import 'dart:convert';

import 'package:aloha/data/response/contact.dart';
import 'package:aloha/data/response/user.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:aloha/utils/constants.dart';
import 'package:http/http.dart';

class UserService {
  Future<ApiResponse<LoginData>> login(
      {required String username, required String password}) async {
    try {
      var response = await post(Uri.https(baseUrl, "/auth/login"),
          body: <String, String>{'username': username, 'password': password});
      if (response.statusCode < 400) {
        var userResponse = userResponseFromJson(response.body);
        return ApiResponse(
            success: true, data: userResponse.data, message: "Success login");
      } else {
        var error = apiErrorResponseFromJson(response.body);
        return ApiResponse(
            success: false,
            data: null,
            message: "Failed to login: " + error.message);
      }
    } catch (e) {
      return ApiResponse(
          success: false,
          data: null,
          message: "Failed to login: " + e.toString());
    }
  }

  Future<ApiResponse<User?>> updateProfile(
      String fullName, String token) async {
    try {
      var response =
          await put(Uri.https(baseUrl, "/user/profile"), body: <String, String>{
        'full_name': fullName
      }, headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode < 400) {
        var data = jsonDecode(response.body);
        var user = User.fromJson(data);
        return ApiResponse(
            success: true, data: user, message: "Success update profile");
      } else {
        var error = apiErrorResponseFromJson(response.body);
        return ApiResponse(
            success: false,
            data: null,
            message: "Failed to update user: " + error.message);
      }
    } catch (e) {
      return ApiResponse(
          success: false,
          data: null,
          message: "Failed to update user: " + e.toString());
    }
  }
}
