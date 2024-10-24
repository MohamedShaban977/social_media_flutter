import 'package:hauui_flutter/core/extensions/map_extensions.dart';

class HashtagModel {
  final int? id;
  final String? name;
  final int? numberOfPosts;

  HashtagModel({
    this.id,
    this.name,
    this.numberOfPosts,
  });

  factory HashtagModel.fromJson(Map<String, dynamic> json) => HashtagModel(
        id: json["id"],
        name: json["name"],
        numberOfPosts: json["number_of_posts"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "number_of_posts": numberOfPosts,
      }..removeNullValues();
}
