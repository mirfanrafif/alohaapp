import 'package:aloha/data/models/agent.dart';
import 'package:aloha/data/preferences/user_preferences.dart';
import 'package:aloha/data/response/Contact.dart';
import 'package:aloha/data/response/User.dart';
import 'package:aloha/data/service/user_service.dart';
import 'package:aloha/utils/ApiResponse.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  late UserService _service;
  late UserPreferences _preferences;

  late AgentEntity _agentEntity;

  UserProvider() {
    _service = UserService();
    _preferences = UserPreferences();
    getUser();
  }

  getUser() async {
    _agentEntity = await _preferences.getUser();
  }

  Future<ApiResponse<LoginData>> login(
      {required String username, required String password}) {
    return _service.login(username: username, password: password).then((value) {
      if (value.success && value.data != null) {
        _agentEntity = AgentEntity(
            id: value.data!.user.id,
            fullName: value.data!.user.fullName,
            username: value.data!.user.username,
            email: value.data!.user.email,
            role: value.data!.user.role,
            profilePhoto: value.data!.user.profilePhoto);
        _preferences.setUser(_agentEntity);
        _preferences.setToken(value.data!.token);
        notifyListeners();
      }
      return value;
    });
  }

  AgentEntity get user => _agentEntity;
}