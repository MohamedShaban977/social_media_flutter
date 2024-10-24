import 'package:hauui_flutter/core/extensions/map_extensions.dart';

class RankModel {
  final int? id;
  final String? title;
  final String? notes;

  RankModel({
    this.id,
    this.title,
    this.notes,
  });

  factory RankModel.fromJson(Map<String, dynamic> json) => RankModel(
        id: json["id"],
        title: json["title"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "notes": notes,
      }..removeNullValues();
}
