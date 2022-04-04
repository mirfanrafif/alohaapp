import 'package:shared_preferences/shared_preferences.dart';

class BasePreferences {
  static late SharedPreferences _preferences;

  static SharedPreferences get preferences => _preferences;

  static init() async {
    _preferences = await SharedPreferences.getInstance();
  }
}
