import 'package:hauui_flutter/core/utils/regex_util.dart';

enum VideoType {
  youtube,
  dailymotion,
  vimeo,
  mp4;
}

extension VideoTypeExtension on VideoType {
  static bool isYoutube(String videoUrl) => RegexUtil.rxYoutube.stringMatch(videoUrl) != null;
  static bool isVimeo(String videoUrl) => RegexUtil.rxVimeoRegex.stringMatch(videoUrl) != null;
  static bool isDailymotion(String videoUrl) => RegexUtil.rxDailymotion.stringMatch(videoUrl) != null;
}
