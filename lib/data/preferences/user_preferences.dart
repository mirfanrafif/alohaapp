import 'package:aloha/data/response/Contact.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/agent.dart';

class UserPreferences {
  final ID = "id";
  final FULL_NAME = "full_name";
  final USERNAME = "username";
  final EMAIL = "email";
  final ROLE = "role";
  final PROFILE_PHOTO = "profile_photo";
  final JWT_TOKEN = "jwt_token";

  Future<AgentEntity> getUser() async {

    var preferences = await SharedPreferences.getInstance();

    var user = AgentEntity(
        id: preferences.getInt("id") ?? 0,
        fullName: preferences.getString("full_name") ?? "",
        username: preferences.getString("username") ?? "",
        email: preferences.getString(EMAIL) ?? "",
        role: preferences.getString(ROLE) ?? "",
        profilePhoto: preferences.getString(PROFILE_PHOTO));
    return user;
  }

  void setUser(AgentEntity agent) async {

    var preferences = await SharedPreferences.getInstance();
    preferences.setInt(ID, agent.id);
    preferences.setString(FULL_NAME, agent.fullName);
    preferences.setString(USERNAME, agent.username);
    preferences.setString(EMAIL, agent.email);
    preferences.setString(ROLE, agent.role);
    preferences.setString(PROFILE_PHOTO, agent.profilePhoto ?? "");
  }

  Future<String> getToken() async {
    var preferences = await SharedPreferences.getInstance();

    return preferences.getString(JWT_TOKEN) ?? "";
  }

  void setToken(String token) async {
    var preferences = await SharedPreferences.getInstance();
    preferences.setString(JWT_TOKEN, token);
  }
}


