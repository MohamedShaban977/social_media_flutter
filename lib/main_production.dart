import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/di/service_locator.dart';

import 'core/network/api_constants.dart';
import 'app/app_config.dart';
import 'app/my_app.dart';
import 'core/constants/enums/app_flavors.dart';
import 'core/managers/shared_pref_manager.dart';
import 'core/utils/app_util.dart';
import 'core/utils/localization_util.dart';

void main() async {
  await _initializeMain();
  ServiceLocator().init();

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationUtil.supportedLocales,
      path: LocalizationUtil.path,
      fallbackLocale: LocalizationUtil.fallbackLocale,
      child: MyApp(),
    ),
  );
}

Future<void> _initializeMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SharedPreferencesManager.init();
  await AppUtil.setPreferredOrientations();

  AppConfig.init(
    baseUrl: ApiConstants.baseUrlProduction,
    mode: AppFlavors.production,
  );
}
