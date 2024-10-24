import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

enum PostLevel {
  beginner(
    id: AppConstants.beginnerLevelId,
    name: LocaleKeys.beginner,
    color: AppColors.veryDarkGrayishBlue,
    backgroundColor: AppColors.darkGrayishBlue,
    widthFillDivider: 3,
  ),
  intermediate(
    id: AppConstants.intermediateLevelId,
    name: LocaleKeys.intermediate,
    color: AppColors.vividCyan,
    backgroundColor: AppColors.vividCyanOpacity46,
    widthFillDivider: 2,
  ),
  advanced(
    id: AppConstants.advancedLevelId,
    name: LocaleKeys.advanced,
    color: AppColors.vividPink,
    widthFillDivider: 1,
  );

  const PostLevel({
    required this.name,
    required this.id,
    required this.color,
    this.backgroundColor,
    required this.widthFillDivider,
  });

  final String name;
  final int id;
  final Color color;
  final Color? backgroundColor;
  final int widthFillDivider;
}

extension PostLevelExtensions on PostLevel {
  String toStr() => name.tr();

  static PostLevel? tryParse(String key, {PostLevel? defaultValue}) {
    try {
      return PostLevel.values.firstWhere((postLevel) => postLevel.name == key);
    } on StateError catch (_) {
      return defaultValue;
    }
  }
}
