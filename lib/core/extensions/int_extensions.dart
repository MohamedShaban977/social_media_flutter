import 'package:easy_localization/easy_localization.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

extension NonNullInteger on int? {
  int orZero() {
    return this ?? 0;
  }

  String getCountInUnit() {
    if ((this ?? 0) >= AppConstants.scaleMillion) {
      return LocaleKeys.countsM.tr(
        args: [
          '${(this ?? 0) / AppConstants.scaleMillion}',
        ],
      );
    } else if ((this ?? 0) >= AppConstants.scaleThousand) {
      return LocaleKeys.countsK.tr(
        args: [
          '${(this ?? 0) / AppConstants.scaleThousand}',
        ],
      );
    } else {
      return toString();
    }
  }
}
