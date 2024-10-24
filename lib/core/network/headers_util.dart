import 'package:easy_localization/easy_localization.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/managers/shared_pref_manager.dart';

class HeadersUtil {
  final _header = {
    "Content-Type": "application/json",
    'Accept': '*/*',
    "Timezone": 'Cairo',
    "Accept-Language": navigatorKey.currentContext!.locale.languageCode,
  };
  final _authorization = {
    "Authorization": '${SharedPreferencesManager.getData(key: AppConstants.prefKeyAccessToken)}',
  };

  Map<String, String> getHeader() {
    if (SharedPreferencesManager.getData(key: AppConstants.prefKeyAccessToken) != null) {
      _header.addEntries(_authorization.entries);
    }
    return _header;
  }
}
