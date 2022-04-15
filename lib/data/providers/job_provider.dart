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

  int? _selectedJobId;
  int? get selectedJobId => _selectedJobId;
  set selectedJobId(int? id) {
    _selectedJobId = id;
    notifyListeners();
  }

  Job? getJob() {
    if (_selectedJobId != null) {
      var jobIndex =
          jobs!.indexWhere((element) => element.id == _selectedJobId!);
      return jobs?[jobIndex];
    } else {
      return null;
    }
  }

  Future<ApiResponse<List<Job>?>> getAllJobs() async {
    var response = await _jobService.getAllJobs(token);
    if (response.success) {
      jobs = response.data!;
    }
    notifyListeners();

    return response;
  }

  Future<ApiResponse<Job?>> saveJob(String name, String desc) async {
    late ApiResponse<Job?> response;
    if (_selectedJobId != null) {
      response =
          await _jobService.updateJob(_selectedJobId!, name, desc, token);
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
}
