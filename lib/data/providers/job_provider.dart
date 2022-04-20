import 'package:aloha/data/preferences/user_preferences.dart';
import 'package:aloha/data/service/job_service.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:flutter/cupertino.dart';

import '../response/job.dart';

class JobProvider extends ChangeNotifier {
  final _jobService = JobService();
  String token = "";
  final _preferences = UserPreferences();

  List<Job>? jobs;

  JobProvider() {
    token = _preferences.getToken();
    getAllJobs();
  }

  Future<ApiResponse<List<Job>?>> getAllJobs() async {
    var response = await _jobService.getAllJobs(token);
    if (response.success) {
      jobs = response.data!;
    }
    notifyListeners();

    return response;
  }

  Future<ApiResponse<Job?>> saveJob(String name, String desc, int? id) async {
    late ApiResponse<Job?> response;
    if (id != null) {
      response = await _jobService.updateJob(id, name, desc, token);
    } else {
      response = await _jobService.addJob(name, desc, token);
    }

    if (response.success) {
      Job data = response.data!;
      var jobIndex = jobs?.indexWhere((element) => element.id == data.id);
      if (jobIndex != null && jobIndex > -1) {
        jobs?[jobIndex] = data;
      } else {
        jobs?.add(data);
      }
    }

    notifyListeners();

    return response;
  }

  Future<ApiResponse<Job?>> deleteJob(int? id) async {
    ApiResponse<Job?> response = await _jobService.deleteJob(id!, token);

    if (response.success) {
      var jobIndex =
          jobs!.indexWhere((element) => element.id == response.data!.id);
      jobs?.removeAt(jobIndex);
    }
    notifyListeners();

    return response;
  }
}
