import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/generated/locale_keys.g.dart';

class SharedPreferencesManager {
  SharedPreferencesManager._();

  static late SharedPreferences _instance;

  static Future<void> init() async => _instance = await SharedPreferences.getInstance();

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is int) {
      return await _instance.setInt(key, value);
    } else if (value is double) {
      return await _instance.setDouble(key, value);
    } else if (value is bool) {
      return await _instance.setBool(key, value);
    } else if (value is String) {
      return await _instance.setString(key, value);
    } else {
      throw Exception(
        LocaleKeys.invalidType.tr(),
      );
    }
  }

  static dynamic getData({
    required String key,
  }) =>
      _instance.get(key);

  static bool containsKey({
    required String key,
  }) =>
      _instance.containsKey(key);

  static Future<bool> remove({
    required String key,
  }) async =>
      await _instance.remove(key);

  static Future<bool> clear() async => await _instance.clear();
}
