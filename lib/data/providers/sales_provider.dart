import 'package:aloha/data/preferences/user_preferences.dart';
import 'package:aloha/data/response/contact.dart';
import 'package:aloha/data/response/job.dart';
import 'package:aloha/data/response/statistics.dart';
import 'package:aloha/data/service/sales_service.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesProvider with ChangeNotifier {
  final UserJobService _jobService = UserJobService();

  final List<Job> _jobs = [];
  List<Job> get jobs => List.unmodifiable(_jobs);

  final List<Agent> _agents = [];
  List<Agent> get agents => List.unmodifiable(_agents);

  Agent? _selectedAgent;
  Agent? get selectedAgent => _selectedAgent;
  set selectedAgent(Agent? agent) {
    _selectedAgent = agent;
    _selectedAgentJob = agent!.job?.id ?? 0;
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

  int _selectedAgentJob = 0;
  int get selectedAgentJob => _selectedAgentJob;
  Future<ApiResponse<Agent?>> setSelectedAgentJob(int newJob) async {
    _selectedAgentJob = newJob;
    var response = await _jobService.updateUserJob(
        _selectedAgent!.id, _selectedAgentJob, _token);

    if (response.success) {
      _selectedAgentJob = response.data!.job?.id ?? 0;
      var agentIndex = findAgentIndex(response.data!.id);
      _agents[agentIndex].job = response.data!.job;
      notifyListeners();
    }
    return response;
  }

  late UserPreferences _preferences;
  String _token = "";

  SalesProvider() {
    _preferences = UserPreferences();
    _token = _preferences.getToken();
    getAllJobs();
    getAllAgents();
  }

  void getAllJobs() async {
    var jobResponse = await _jobService.getAllJobs(_token);
    _jobs.addAll(jobResponse);
    notifyListeners();
  }

  void getAllAgents() async {
    var users = await _jobService.getAllUsers(_token);
    _agents.addAll(users);
    notifyListeners();
  }

  int findAgentIndex(int agentId) {
    return _agents.indexWhere((element) => element.id == agentId);
  }

  Future<ApiResponse<Agent?>> updateAgents(
      String nama, String username, String email) async {
    var role = _selectedAgent!.role;
    var response = await _jobService.updateUser(
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
    var response = await _jobService.getStatistics(
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
