import 'dart:convert';

import 'package:aloha/data/response/contact.dart';
import 'package:aloha/data/response/statistics.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:aloha/utils/constants.dart';
import 'package:http/http.dart';

import '../response/user.dart';

class SalesService {
  Future<ApiResponse<List<User>?>> getAllUsers(String token) async {
    try {
      var response = await get(Uri.https(baseUrl, '/user'),
          headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode < 400) {
        var data = GetAllUserResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true, data: data.data, message: data.message);
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

  Future<ApiResponse<User?>> updateUser(
      {required int id,
      required String nama,
      required String username,
      required String email,
      required String role,
      required String token}) async {
    try {
      Map<String, dynamic> request = {
        'full_name': nama,
        'username': username,
        'email': email,
        'role': role
      };
      var response = await put(Uri.https(baseUrl, '/user/manage/$id'),
          body: request, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode < 400) {
        var responseData =
            UpdateUserResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true,
            data: responseData.data,
            message: 'Sukses mengubah data sales');
      } else {
        var errorResponse =
            ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false,
            data: null,
            message: 'Gagal mengupdate data sales: ${errorResponse.message}');
      }
    } catch (e) {
      return ApiResponse(
          success: false,
          data: null,
          message: 'Gagal mengupdate data sales: ${e.toString()}');
    }
  }

  Future<ApiResponse<User?>> addUser({
    required String nama,
    required String username,
    required String email,
    required String password,
    required String role,
    required String token,
  }) async {
    try {
      Map<String, dynamic> request = {
        'full_name': nama,
        'username': username,
        'email': email,
        'password': password,
        'role': role
      };
      var response = await post(Uri.https(baseUrl, '/user'),
          body: request, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode < 400) {
        var responseData =
            UpdateUserResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true,
            data: responseData.data,
            message: 'Sukses mengubah data sales');
      } else {
        var errorResponse =
            ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false,
            data: null,
            message: 'Gagal mengupdate data sales: ${errorResponse.message}');
      }
    } catch (e) {
      return ApiResponse(
          success: false,
          data: null,
          message: 'Gagal mengupdate data sales: ${e.toString()}');
    }
  }

  Future<ApiResponse<User?>> assignUserJob(
      int agentId, int jobId, String token) async {
    Map<String, dynamic> requestData = {'agentId': agentId, 'jobId': jobId};
    var requestJson = jsonEncode(requestData);
    try {
      var response = await post(Uri.https(baseUrl, '/user/job/assign'),
          body: requestJson,
          headers: {
            'Authorization': 'Bearer $token',
            "content-type": "application/json"
          });
      if (response.statusCode < 400) {
        var responseData =
            UpdateUserResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true,
            data: responseData.data,
            message: 'Sukses mengubah data sales');
      } else {
        var errorResponse =
            ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false,
            data: null,
            message: 'Gagal mengupdate data sales: ${errorResponse.message}');
      }
    } catch (e) {
      return ApiResponse(
          success: false,
          data: null,
          message: 'Gagal mengupdate data sales: ${e.toString()}');
    }
  }

  Future<ApiResponse<User?>> unassignUserJob(
      int agentId, int jobId, String token) async {
    Map<String, dynamic> requestData = {'agentId': agentId, 'jobId': jobId};
    var requestJson = jsonEncode(requestData);
    try {
      var response = await post(Uri.https(baseUrl, '/user/job/unassign'),
          body: requestJson,
          headers: {
            'Authorization': 'Bearer $token',
            "content-type": "application/json"
          });
      if (response.statusCode < 400) {
        var responseData =
            UpdateUserResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true,
            data: responseData.data,
            message: 'Sukses mengubah data sales');
      } else {
        var errorResponse =
            ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false,
            data: null,
            message: 'Gagal mengupdate data sales: ${errorResponse.message}');
      }
    } catch (e) {
      return ApiResponse(
          success: false,
          data: null,
          message: 'Gagal mengupdate data sales: ${e.toString()}');
    }
  }

  Future<ApiResponse<StatisticsResponse?>> getStatistics(
      {required int agentId,
      required String token,
      required String startDate,
      required String endDate}) async {
    try {
      var response = await get(
          Uri.https(baseUrl, "/user/manage/$agentId/stats",
              {'start': startDate, 'end': endDate}),
          headers: {
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode < 400) {
        return ApiResponse(
            success: true,
            data: StatisticsResponse.fromJson(jsonDecode(response.body)),
            message: 'Sukses mengambil statistik');
      } else {
        var errorResponse =
            ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false,
            data: null,
            message: 'Gagal mengambil statistik: ${errorResponse.message}');
      }
    } catch (e) {
      return ApiResponse(
          success: false,
          data: null,
          message: 'Gagal mengambil statistik: ${e.toString()}');
    }
  }

  Future<ApiResponse<User?>> changePassword(
      int id, String newPassword, String token) async {
    try {
      var requestData = {'newPassword': newPassword};
      var response = await put(Uri.https(baseUrl, '/user/manage/$id/password'),
          body: requestData, headers: {'Authorization': 'Bearer ' + token});
      if (response.statusCode < 400) {
        var responseData =
            UpdateUserResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true,
            data: responseData.data,
            message: 'Success change password');
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

  Future<ApiResponse<User?>> deleteUser(
      int salesId, int delegatedSalesId, String token) async {
    try {
      var requestData = {
        'salesId': salesId,
        'delegatedSalesId': delegatedSalesId
      };
      var response = await delete(Uri.https(baseUrl, '/user/manage'),
          body: jsonEncode(requestData),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });
      if (response.statusCode < 400) {
        var responseData =
            UpdateUserResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true,
            data: responseData.data,
            message: responseData.message);
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

  Future<ApiResponse<User?>> deactivateUser(int salesId, String token) async {
    try {
      var response = await put(
          Uri.https(baseUrl, '/user/manage/$salesId/deactivate'),
          headers: {
            'Authorization': 'Bearer ' + token,
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });
      if (response.statusCode < 400) {
        var responseData =
            UpdateUserResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: true,
            data: responseData.data,
            message: responseData.message);
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
