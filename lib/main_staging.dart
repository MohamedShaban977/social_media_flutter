import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/di/service_locator.dart';

import 'app/app_config.dart';
import 'app/my_app.dart';
import 'core/constants/enums/app_flavors.dart';
import 'core/managers/shared_pref_manager.dart';
import 'core/network/api_constants.dart';
import 'core/utils/app_util.dart';
import 'core/utils/localization_util.dart';
import 'firebase_options_staging.dart';

void main() async {
  await _initializeMain();
  ServiceLocator().init();

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationUtil.supportedLocales,
      path: LocalizationUtil.path,
      fallbackLocale: LocalizationUtil.fallbackLocale,
      child: ProviderScope(child: MyApp()),
    ),
  );
}

Future<void> _initializeMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  await SharedPreferencesManager.init();
  await AppUtil.setPreferredOrientations();

  AppConfig.init(
    baseUrl: ApiConstants.baseUrlStaging,
    mode: AppFlavors.staging,
  );
}
