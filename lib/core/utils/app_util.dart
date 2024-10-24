import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUtil {
  static Future<PackageInfo> getAppInfo() async =>
      await PackageInfo.fromPlatform();

  static Future<void> setPreferredOrientations() async =>
      await SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      );
}
