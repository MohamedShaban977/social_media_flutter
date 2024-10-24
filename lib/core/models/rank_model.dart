import 'package:hauui_flutter/core/extensions/map_extensions.dart';
import 'package:hauui_flutter/core/utils/json_util.dart';

class RankModel {
  final int? id;
  final String? title;
  final String? arTitle;
  final int? postsCount;
  final int? likesCount;
  final int? commentsCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? sharesCount;
  final String? notesEn;
  final String? notesAr;

  RankModel({
    this.id,
    this.title,
    this.arTitle,
    this.postsCount,
    this.likesCount,
    this.commentsCount,
    this.createdAt,
    this.updatedAt,
    this.sharesCount,
    this.notesEn,
    this.notesAr,
  });

  factory RankModel.fromJson(Map<String, dynamic> json) => RankModel(
        id: json["id"],
        title: json["title"],
        arTitle: json["ar_title"],
        postsCount: json["posts_count"],
        likesCount: json["likes_count"],
        commentsCount: json["comments_count"],
        createdAt: JsonUtil.convertEmptyToNull(
          json['created_at'],
          (data) => JsonUtil.deserializeObject(
            data,
            (element) => DateTime.parse(element),
          ),
        ),
        updatedAt: JsonUtil.convertEmptyToNull(
          json['updated_at'],
          (data) => JsonUtil.deserializeObject(
            data,
            (element) => DateTime.parse(element),
          ),
        ),
        sharesCount: json["shares_count"],
        notesEn: json["notes_en"],
        notesAr: json["notes_ar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "ar_title": arTitle,
        "posts_count": postsCount,
        "likes_count": likesCount,
        "comments_count": commentsCount,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "shares_count": sharesCount,
        "notes_en": notesEn,
        "notes_ar": notesAr,
      }..removeNullValues();
}
