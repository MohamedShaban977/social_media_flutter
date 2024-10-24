import 'package:hauui_flutter/core/extensions/map_extensions.dart';
import 'package:hauui_flutter/core/utils/json_util.dart';

class LevelModel {
  final int? id;
  final String? name;
  final String? arName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LevelModel({
    this.id,
    this.name,
    this.arName,
    this.createdAt,
    this.updatedAt,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json["id"],
      name: json["name"],
      arName: json["ar_name"],
      createdAt: JsonUtil.deserializeObject(
          json["created_at"] == '' ? null : json["created_at"], (element) => DateTime.parse(element)),
      updatedAt: JsonUtil.deserializeObject(
          json["updated_at"] == '' ? null : json["updated_at"], (element) => DateTime.parse(element)),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ar_name": arName,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      }..removeNullValues();
}
