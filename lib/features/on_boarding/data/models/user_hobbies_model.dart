import 'package:hauui_flutter/core/extensions/map_extensions.dart';
import 'package:hauui_flutter/core/models/hobby_model.dart';
import 'package:hauui_flutter/core/utils/json_util.dart';

class UserHobbiesModel {
  final int? id;
  final String? name;
  final List<HobbyModel>? hobbies;

  UserHobbiesModel({
    this.id,
    this.name,
    this.hobbies,
  });

  factory UserHobbiesModel.fromJson(Map<String, dynamic> json) => UserHobbiesModel(
        id: json["id"],
        name: json["name"],
        hobbies: JsonUtil.deserializeList(json['hobbies'], (data) => HobbyModel.fromJson(data)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "hobbies": hobbies == null ? [] : List<dynamic>.from(hobbies!.map((x) => x.toJson())),
      }..removeNullValues();
}
