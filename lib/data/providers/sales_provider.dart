import 'package:aloha/data/preferences/user_preferences.dart';
import 'package:aloha/data/response/contact.dart';
import 'package:aloha/data/response/job.dart';
import 'package:aloha/data/response/statistics.dart';
import 'package:aloha/data/service/job_service.dart';
import 'package:aloha/data/service/sales_service.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesProvider with ChangeNotifier {
  final SalesService _salesService = SalesService();
  final JobService _jobService = JobService();

  final List<Job> _jobs = [];
  List<Job> get jobs => List.unmodifiable(_jobs);

  final List<User> _agents = [];
  List<User> get agents => List.unmodifiable(_agents);

  User? _selectedAgent;
  User? get selectedAgent => _selectedAgent;
  set selectedAgent(User? agent) {
    _selectedAgent = agent;
    _selectedAgentJob = agent!.job?.map((e) => e.job).toList() ?? [];
    _selectedDate = null;
    _dailyReport = null;
    statisticsResponse = null;
    statistics = null;
    _selectedCustomerId = null;
    notifyListeners();
  }

  void setSelectedAgentRole(String newRole) {
    _selectedAgent?.role = newRole;
    notifyListeners();
  }

  List<Job> _selectedAgentJob = [];
  List<Job> get selectedAgentJob => _selectedAgentJob;
  Future<void> setSelectedAgentJob(
      bool assign, Job job, BuildContext context) async {
    if (assign) {
      var response =
          await _salesService.assignUserJob(_selectedAgent!.id, job.id, _token);

      if (response.success) {
        _selectedAgentJob =
            _selectedAgentJob = response.data!.job!.map((e) => e.job).toList();
        var agentIndex = findAgentIndex(response.data!.id);
        _agents[agentIndex].job = response.data!.job;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(response.message)));
    } else {
      var response = await _salesService.unassignUserJob(
          _selectedAgent!.id, job.id, _token);

      if (response.success) {
        _selectedAgentJob = response.data!.job!.map((e) => e.job).toList();
        var agentIndex = findAgentIndex(response.data!.id);
        _agents[agentIndex].job = response.data!.job;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.message)));
    }
    notifyListeners();
  }

  late UserPreferences _preferences;
  String _token = "";

  void init(BuildContext context) {
    _preferences = UserPreferences();
    _token = _preferences.getToken();
    getAllJobs();
    getAllAgents().then((value) {
      if (!value.success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value.message)));
      }
    });
  }

  void getAllJobs() async {
    _jobs.clear();
    var jobResponse = await _jobService.getAllJobs(_token);
    if (jobResponse.success && jobResponse.data != null) {
      _jobs.addAll(jobResponse.data!);
    }
    notifyListeners();
  }

  Future<ApiResponse<List<User>?>> getAllAgents() async {
    _agents.clear();
    var users = await _salesService.getAllUsers(_token);
    if (users.success && users.data != null) {
      _agents.addAll(users.data!);
    }
    notifyListeners();
    return users;
  }

  int findAgentIndex(int agentId) {
    return _agents.indexWhere((element) => element.id == agentId);
  }

  Future<ApiResponse<User?>> updateAgents(
      String nama, String username, String email) async {
    var role = _selectedAgent!.role;
    var response = await _salesService.updateUser(
        id: _selectedAgent!.id,
        nama: nama,
        username: username,
        email: email,
        role: role,
        token: _token);
    if (response.data != null) {
      var newAgent = response.data!;
      _selectedAgent = newAgent;
      var agentIndex = findAgentIndex(_selectedAgent!.id);
      if (agentIndex > -1) {
        _agents[agentIndex].fullName = newAgent.fullName;
        _agents[agentIndex].email = newAgent.email;
        _agents[agentIndex].username = newAgent.username;
        _agents[agentIndex].role = newAgent.role;
      }
      notifyListeners();
    }
    return response;
  }

  DateTimeRange? _selectedDate;
  DateTimeRange? get selectedDate => _selectedDate;
  set selectedDate(DateTimeRange? newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }

  getFormattedStartDate() {
    return _selectedDate != null ? _formatDate(_selectedDate!.start) : "";
  }

  getFormattedEndDate() {
    return _selectedDate != null ? _formatDate(_selectedDate!.end) : "";
  }

  String _formatDate(DateTime date) {
    return DateFormat('y-M-d').format(date);
  }

  StatisticsResponse? statisticsResponse;

  Future<ApiResponse<StatisticsResponse?>> getStatistics() async {
    statisticsResponse = null;
    statistics = null;
    _selectedCustomerId = null;
    var response = await _salesService.getStatistics(
        agentId: _selectedAgent!.id,
        token: _token,
        startDate: getFormattedStartDate(),
        endDate: getFormattedEndDate());

    if (response.data != null) {
      statisticsResponse = response.data;
      statisticsResponse?.statistics?.removeWhere(
        (element) => element.dailyReport?.isEmpty ?? false,
      );
      notifyListeners();
    }

    return response;
  }

  int? _selectedCustomerId;
  int? get selectedCustomerId => _selectedCustomerId;

  Statistics? statistics;

  void changeSelectedCustomer(int newValue) {
    _selectedCustomerId = newValue;
    var selectedCustomerIndex = statisticsResponse?.statistics
        ?.indexWhere((element) => element.id == newValue);
    if (selectedCustomerIndex != null) {
      statistics = statisticsResponse?.statistics?[selectedCustomerIndex];
    }
    _selectedReport = null;
    _dailyReport = null;
    notifyListeners();
  }

  DailyReport? _dailyReport;
  DailyReport? get dailyReport => _dailyReport;

  String? _selectedReport;
  String? get selectedReport => _selectedReport;
  set selectedReport(String? newValue) {
    _selectedReport = newValue;
    var reportIndex =
        statistics?.dailyReport?.indexWhere((e) => e.date == newValue);
    if (reportIndex != null) {
      _dailyReport = statistics?.dailyReport?[reportIndex];
    }
    notifyListeners();
  }
}
