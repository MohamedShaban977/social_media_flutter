import 'package:hauui_flutter/core/extensions/map_extensions.dart';

class HobbyLevelIdentifiersModel {
  final int hobbyId;
  final int levelId;

  HobbyLevelIdentifiersModel({
    required this.hobbyId,
    required this.levelId,
  });

  Map<String, dynamic> toJson() => {
        "hobby_id": hobbyId,
        "level_id": levelId,
      }..removeNullValues();
}
