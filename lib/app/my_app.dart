import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../core/constants/app_globals.dart';
import '../core/constants/routes/app_routes.dart';
import '../core/constants/routes/routes_names.dart';
import '../core/managers/theme/theme_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp._internal();

  // singleton or single instance
  static const MyApp _instance = MyApp._internal();

  factory MyApp() => _instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeManager.getThemeData(),
      localizationsDelegates: [...context.localizationDelegates],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateRoute: AppRoutes().generateRoute,
      navigatorKey: navigatorKey,
      builder: FToastBuilder(),
      initialRoute: RoutesNames.initialRoute,
    );
  }
}
