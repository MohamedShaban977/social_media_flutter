import 'package:easy_localization/easy_localization.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

extension DateTimeExtensions on DateTime {
  String getDayName() {
    final diff = difference(DateTime.now()).inDays;
    if (diff == 0) {
      return LocaleKeys.today.tr();
    } else if (diff == -1) {
      return LocaleKeys.yesterday.tr();
    } else {
      return DateFormat(AppConstants.patternYMMMD).format(this);
    }
  }

  /// ex: 1 Jun 2023 - 6:10 PM
  String formatFullDateTime(String locale) {
    final day = DateFormat.d().format(this);
    final month = DateFormat.MMM().format(this);
    final year = DateFormat.y().format(this);
    final time = getFormattedDateTime(locale, AppConstants.patternHMMA);
    return '$day $month $year - $time';
  }

  String getFormattedDateTime(String locale, String pattern) => DateFormat(pattern, locale).format(this);

  String getDateWithDayName() {
    final diff = DateTime.now().difference(this).inDays;
    if (diff == 0) {
      return '${LocaleKeys.today.tr()}, ${DateFormat(AppConstants.patternDDMMMYYYY).format(this)}';
    } else if (diff == -1) {
      return '${LocaleKeys.yesterday.tr()}, ${DateFormat(AppConstants.patternDDMMMYYYY).format(this)}';
    } else {
      return DateFormat(AppConstants.patternEEEDDMMMYYYY).format(this);
    }
  }
}
