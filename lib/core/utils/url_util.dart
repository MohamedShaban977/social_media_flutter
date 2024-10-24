import 'package:easy_localization/easy_localization.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlUtil {
  UrlUtil._();

  static Future<bool> launchURL({
    required String url,
    String? scheme,
    LaunchMode mode = LaunchMode.platformDefault,
    String? errorMessage,
  }) async {
    var uri = scheme == null ? Uri.parse(url) : Uri(scheme: scheme, path: url);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: mode);
    } else {
      throw Exception(
        errorMessage ?? LocaleKeys.couldNotLaunchUrl.tr(args: [url]),
      );
    }
  }
}
