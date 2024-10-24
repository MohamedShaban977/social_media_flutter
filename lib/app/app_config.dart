import '../core/constants/enums/app_flavors.dart';

AppConfig? get configs => _env;
AppConfig? _env;

class AppConfig {
  final String baseUrl;
  final AppFlavors mode;

  AppConfig._init({
    required this.baseUrl,
    required this.mode,
  });

  static void init({
    required baseUrl,
    required AppFlavors mode,
  }) =>
      _env ??= AppConfig._init(baseUrl: baseUrl, mode: mode);
}
