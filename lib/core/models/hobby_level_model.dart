import 'package:hauui_flutter/core/extensions/map_extensions.dart';
import 'package:hauui_flutter/core/utils/json_util.dart';

import 'hobby_model.dart';
import 'level_model.dart';

class HobbyLevelModel {
  final int? id;
  final HobbyModel? hobby;
  final LevelModel? level;

  HobbyLevelModel({
    this.id,
    this.hobby,
    this.level,
  });

  factory HobbyLevelModel.fromJson(Map<String, dynamic> json) =>
      HobbyLevelModel(
        id: json["id"],
        hobby: JsonUtil.deserializeObject(json['hobby'], (data) => HobbyModel.fromJson(data)),
        level: JsonUtil.deserializeObject(json['level'], (data) => LevelModel.fromJson(data)),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "hobby": hobby?.toJson(),
        "level": level?.toJson(),
      }
        ..removeNullValues();
}
