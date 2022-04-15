import 'package:aloha/data/models/agent.dart';
import 'package:aloha/data/preferences/user_preferences.dart';
import 'package:aloha/data/response/user.dart';
import 'package:aloha/data/service/user_service.dart';
import 'package:aloha/utils/api_response.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  late UserService _service;
  late UserPreferences _preferences;

  late AgentEntity _agentEntity;

  late String _token;

  UserProvider() {
    _service = UserService();
    _preferences = UserPreferences();
    _agentEntity = _preferences.getUser();
    _token = _preferences.getToken();
  }

  Future<ApiResponse<LoginData>> login(
      {required String username, required String password}) async {
    var value = await _service.login(username: username, password: password);
    if (value.success && value.data != null) {
      _agentEntity = AgentEntity(
          id: value.data!.user.id,
          fullName: value.data!.user.fullName,
          username: value.data!.user.username,
          email: value.data!.user.email,
          role: value.data!.user.role,
          profilePhoto: value.data!.user.profilePhoto);
      _token = value.data!.token;
      //set preferences
      _preferences.setUser(_agentEntity);
      _preferences.setToken(value.data!.token);
      notifyListeners();
    }
    return value;
  }

  String get token => _token;

  AgentEntity get user => _agentEntity;
}
