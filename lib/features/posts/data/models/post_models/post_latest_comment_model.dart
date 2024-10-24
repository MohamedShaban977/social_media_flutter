import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/core/models/media_model.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/utils/json_util.dart';

class PostLatestCommentModel {
  int? id;
  String? body;
  List<IntKeyStingValueModel>? mentionedUsers;
  List<MediaModel>? mediaAttributes;
  DateTime? createdAt;
  int? repliesCount;
  UserModel? owner;

  PostLatestCommentModel({
    this.id,
    this.body,
    this.mentionedUsers,
    this.mediaAttributes,
    this.createdAt,
    this.repliesCount,
    this.owner,
  });

  PostLatestCommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    body = json['body'];
    mentionedUsers = JsonUtil.deserializeList(json['mentioned_users'], (data) => IntKeyStingValueModel.fromJson(data));
    mediaAttributes = JsonUtil.deserializeList(json['media_attributes'], (data) => MediaModel.fromJson(data));
    createdAt = JsonUtil.deserializeObject(json['created_at'], (element) => DateTime.parse(element));
    repliesCount = json['replies_count'];
    owner = JsonUtil.deserializeObject(json['owner'], (element) => UserModel.fromJson(element));
  }
}
