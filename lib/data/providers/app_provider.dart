import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppProvider extends ChangeNotifier {
  String appVersion = "";

  void getAppVersion() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    appVersion = info.version;
    notifyListeners();
  }
}
