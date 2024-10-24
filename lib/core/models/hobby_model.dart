import 'package:hauui_flutter/core/extensions/map_extensions.dart';
import 'package:hauui_flutter/core/utils/json_util.dart';

class HobbyModel {
  final int? id;
  final String? name;
  final String? arName;
  final int? parentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final int? numberOfPosts;

  final bool? shouldBeSelected;
  final List<HobbyModel>? subHobbies;

  HobbyModel({
    this.id,
    this.name,
    this.arName,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.numberOfPosts,
    this.shouldBeSelected,
    this.subHobbies,
  });

  factory HobbyModel.fromJson(Map<String, dynamic> json) => HobbyModel(
        id: json['id'],
        name: json['name'],
        arName: json['ar_name'],
        parentId: json['parent_id'],
        createdAt: JsonUtil.deserializeObject(json['created_at'], (element) => DateTime.parse(element)),
        updatedAt: JsonUtil.deserializeObject(json['updated_at'], (element) => DateTime.parse(element)),
        numberOfPosts: json["number_of_posts"],
        shouldBeSelected: json["should_be_selected"],
        subHobbies: JsonUtil.deserializeList<HobbyModel>(
          json["sub_hobbies"],
          (data) => HobbyModel.fromJson(data),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ar_name": arName,
        "parent_id": parentId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "number_of_posts": numberOfPosts,
        "should_be_selected": shouldBeSelected,
        "sub_hobbies": subHobbies == null ? [] : List<dynamic>.from(subHobbies!.map((x) => x.toJson())),
      }..removeNullValues();
}
