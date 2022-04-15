import 'package:aloha/data/preferences/base_preferences.dart';

import '../models/agent.dart';

class UserPreferences {
  final _id = "id";
  final _fullName = "full_name";
  final _username = "username";
  final _email = "email";
  final _role = "role";
  final _profilePhoto = "profile_photo";
  final _jwtToken = "jwt_token";
  var preferences = BasePreferences.preferences;

  AgentEntity getUser() {
    var user = AgentEntity(
        id: preferences.getInt("id") ?? 0,
        fullName: preferences.getString("full_name") ?? "",
        username: preferences.getString("username") ?? "",
        email: preferences.getString(_email) ?? "",
        role: preferences.getString(_role) ?? "",
        profilePhoto: preferences.getString(_profilePhoto));
    return user;
  }

  void setUser(AgentEntity agent) {
    preferences.setInt(_id, agent.id);
    preferences.setString(_fullName, agent.fullName);
    preferences.setString(_username, agent.username);
    preferences.setString(_email, agent.email);
    preferences.setString(_role, agent.role);
    preferences.setString(_profilePhoto, agent.profilePhoto ?? "");
  }

  String getToken() {
    return preferences.getString(_jwtToken) ?? "";
  }

  void setToken(String token) async {
    preferences.setString(_jwtToken, token);
  }

  void logout() {
    preferences.clear();
  }
}
