import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';

class LocalizationUtil {
  static const List<Locale> supportedLocales = [
    Locale(
      AppConstants.enLangCode,
      AppConstants.enCountryCode,
    ),
    Locale(
      AppConstants.arLangCode,
      AppConstants.arCountryCode,
    ),
  ];
  static const String path = 'assets/translations';
  static const Locale fallbackLocale = Locale(
    AppConstants.enLangCode,
    AppConstants.enCountryCode,
  );
}
