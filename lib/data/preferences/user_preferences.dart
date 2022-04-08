import 'package:aloha/data/preferences/base_preferences.dart';

import '../models/agent.dart';

class UserPreferences {
  final ID = "id";
  final FULL_NAME = "full_name";
  final USERNAME = "username";
  final EMAIL = "email";
  final ROLE = "role";
  final PROFILE_PHOTO = "profile_photo";
  final JWT_TOKEN = "jwt_token";
  var preferences = BasePreferences.preferences;

  AgentEntity getUser() {
    var user = AgentEntity(
        id: preferences.getInt("id") ?? 0,
        fullName: preferences.getString("full_name") ?? "",
        username: preferences.getString("username") ?? "",
        email: preferences.getString(EMAIL) ?? "",
        role: preferences.getString(ROLE) ?? "",
        profilePhoto: preferences.getString(PROFILE_PHOTO));
    return user;
  }

  void setUser(AgentEntity agent) {
    preferences.setInt(ID, agent.id);
    preferences.setString(FULL_NAME, agent.fullName);
    preferences.setString(USERNAME, agent.username);
    preferences.setString(EMAIL, agent.email);
    preferences.setString(ROLE, agent.role);
    preferences.setString(PROFILE_PHOTO, agent.profilePhoto ?? "");
  }

  String getToken() {
    return preferences.getString(JWT_TOKEN) ?? "";
  }

  void setToken(String token) async {
    preferences.setString(JWT_TOKEN, token);
  }

  void logout() {
    preferences.clear();
  }
}
