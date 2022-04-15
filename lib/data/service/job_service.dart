import 'dart:convert';

import 'package:aloha/data/response/job.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:aloha/utils/constants.dart';
import 'package:http/http.dart';

class JobService {
  Future<ApiResponse<List<Job>?>> getAllJobs(String token) async {
    try {
      var response = await get(Uri.https(BASE_URL, '/user/job'));
      if (response.statusCode < 400) {
        var data = jobFromJson(response.body);
        return ApiResponse(
            success: true, data: data, message: 'Sukses mengambil data job');
      } else {
        var errorResponse =
            ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false,
            data: null,
            message: 'Gagal mengambil data job : ' + errorResponse.message);
      }
    } catch (e) {
      return ApiResponse(
          success: false,
          data: [],
          message: 'Gagal mengambil data job : ' + e.toString());
    }
  }

  Future<ApiResponse<Job?>> updateJob(
      int id, String nama, String desc, String token) async {
    try {
      var requestData = {'name': nama, 'description': desc};

      var response = await put(Uri.https(BASE_URL, '/user/job/$id'),
          body: requestData, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode < 400) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        var data = Job.fromJson(responseData['data']);
        return ApiResponse(
            success: true, data: data, message: 'Sukses mengambil data job');
      } else {
        var errorResponse =
            ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false,
            data: null,
            message: 'Gagal mengambil data job : ' + errorResponse.message);
      }
    } catch (e) {
      return ApiResponse(
          success: false,
          data: null,
          message: 'Gagal mengambil data job : ' + e.toString());
    }
  }

  Future<ApiResponse<Job?>> addJob(
      String nama, String desc, String token) async {
    try {
      var requestData = {'name': nama, 'description': desc};

      var response = await post(Uri.https(BASE_URL, '/user/job'),
          body: requestData, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode < 400) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        var data = Job.fromJson(responseData);
        return ApiResponse(
            success: true, data: data, message: 'Sukses mengambil data job');
      } else {
        var errorResponse =
            ApiErrorResponse.fromJson(jsonDecode(response.body));
        return ApiResponse(
            success: false,
            data: null,
            message: 'Gagal mengambil data job : ' + errorResponse.message);
      }
    } catch (e) {
      return ApiResponse(
          success: false,
          data: null,
          message: 'Gagal mengambil data job : ' + e.toString());
    }
  }
}
