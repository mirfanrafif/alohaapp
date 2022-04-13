import 'dart:convert';

import 'package:aloha/data/response/contact.dart';
import 'package:aloha/data/response/job.dart';
import 'package:aloha/data/response/statistics.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:aloha/utils/constants.dart';
import 'package:http/http.dart';

import '../response/User.dart';

class UserJobService {
  Future<List<Job>> getAllJobs(String token) async {
    try {
      var response = await get(Uri.https(BASE_URL, '/user/job'),
          headers: {'Authorization': 'Bearer $token'});

      var jobs = jobFromJson(response.body);
      return jobs;
    } catch (e) {
      return [];
    }
  }

  Future<List<Agent>> getAgentFromJobId(int jobId, String token) async {
    try {
      var response = await get(Uri.https(BASE_URL, '/user/job/$jobId'),
          headers: {'Authorization': 'Bearer $token'});

      var job = JobResponse.fromJson(jsonDecode(response.body));
      if (job.data.agents != null) {
        return job.data.agents!;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Agent>> getAllUsers(String token) async {
    try {
      var response = await get(Uri.https(BASE_URL, '/user'),
          headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode < 400) {
        var data = GetAllUserResponse.fromJson(jsonDecode(response.body));
        return data.data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<ApiResponse<Agent?>> updateUser(
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
      var response = await put(Uri.https(BASE_URL, '/user/manage/$id'),
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

  Future<ApiResponse<Agent?>> updateUserJob(
      int agentId, int jobId, String token) async {
    Map<String, dynamic> requestData = {'agentId': agentId, 'jobId': jobId};
    var requestJson = jsonEncode(requestData);
    try {
      var response = await post(Uri.https(BASE_URL, '/user/job/assign'),
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
          Uri.https(BASE_URL, "/user/manage/$agentId/stats",
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
}
