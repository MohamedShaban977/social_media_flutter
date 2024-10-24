import 'package:hauui_flutter/core/models/hashtag_model.dart';
import 'package:hauui_flutter/core/models/hobby_level_model.dart';
import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/utils/json_util.dart';
import 'package:hauui_flutter/core/models/media_model.dart';
import 'package:hauui_flutter/features/posts/data/models/post_models/post_latest_comment_model.dart';
import 'package:hauui_flutter/features/posts/data/models/post_models/post_step_model.dart';

class PostModel {
  int? id;
  String? title;
  String? description;
  int? likesCount;
  int? sharesCount;
  int? commentsCount;
  String? status;
  int? cityId;
  double? lat;
  double? long;
  late bool isLiked;
  late bool isShared;
  late bool isSaved;
  late bool isSharedPost;
  String? dynamicLink;
  DateTime? createdAt;
  List<MediaModel>? mediaAttributes;
  List<PostStepModel>? stepsAttributes;
  List<HashtagModel>? hashtags;
  List<HobbyLevelModel>? hobbies;
  UserModel? owner;
  PostLatestCommentModel? latestComment;
  List<IntKeyStingValueModel>? mentionedUsers;
  IntKeyStingValueModel? level;

  PostModel({
    this.id,
    this.title,
    this.description,
    this.likesCount,
    this.sharesCount,
    this.commentsCount,
    this.status,
    this.cityId,
    this.lat,
    this.long,
    this.isLiked = false,
    this.isShared = false,
    this.isSaved = false,
    this.isSharedPost = false,
    this.dynamicLink,
    this.createdAt,
    this.mediaAttributes,
    this.stepsAttributes,
    this.hashtags,
    this.hobbies,
    this.owner,
    this.latestComment,
    this.mentionedUsers,
    this.level,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    likesCount = json['likes_count'];
    sharesCount = json['shares_count'];
    commentsCount = json['comments_count'];
    status = json['status'];
    cityId = json['city_id'];
    lat = json['lat'];
    long = json['long'];
    isLiked = json['is_liked'];
    isShared = json['is_shared'];
    isSaved = json['is_saved'];
    isSharedPost = json['is_shared_post'];
    dynamicLink = json['dynamic_link'];
    createdAt = JsonUtil.deserializeObject(json['created_at'], (element) => DateTime.parse(element));
    mediaAttributes = JsonUtil.deserializeList(json['media_attributes'], (data) => MediaModel.fromJson(data));
    stepsAttributes = JsonUtil.deserializeList(json['steps_attributes'], (data) => PostStepModel.fromJson(data));
    hashtags = JsonUtil.deserializeList(json['hashtags'], (data) => HashtagModel.fromJson(data));
    hobbies = JsonUtil.deserializeList(json['hobbies'], (data) => HobbyLevelModel.fromJson(data));
    owner = JsonUtil.deserializeObject(json['owner'], (data) => UserModel.fromJson(data));
    latestComment = JsonUtil.deserializeObject(json['latest_comment'], (data) => PostLatestCommentModel.fromJson(data));
    mentionedUsers = JsonUtil.deserializeList(json['mentioned_users'], (data) => IntKeyStingValueModel.fromJson(data));
    level = JsonUtil.deserializeObject(json['level'], (data) => IntKeyStingValueModel.fromJson(data));
  }

  PostModel copyWith({
    int? id,
    String? title,
    String? description,
    int? likesCount,
    int? sharesCount,
    int? commentsCount,
    String? status,
    int? cityId,
    double? lat,
    double? long,
    bool? isLiked,
    bool? isShared,
    bool? isSaved,
    bool? isSharedPost,
    String? dynamicLink,
    DateTime? createdAt,
    List<MediaModel>? mediaAttributes,
    List<PostStepModel>? stepsAttributes,
    List<HashtagModel>? hashtags,
    List<HobbyLevelModel>? hobbies,
    UserModel? owner,
    PostLatestCommentModel? latestComment,
    List<IntKeyStingValueModel>? mentionedUsers,
    IntKeyStingValueModel? level,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      likesCount: likesCount ?? this.likesCount,
      sharesCount: sharesCount ?? this.sharesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      status: status ?? this.status,
      cityId: cityId ?? this.cityId,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      isLiked: isLiked ?? this.isLiked,
      isShared: isShared ?? this.isShared,
      isSaved: isSaved ?? this.isSaved,
      isSharedPost: isSharedPost ?? this.isSharedPost,
      dynamicLink: dynamicLink ?? this.dynamicLink,
      createdAt: createdAt ?? this.createdAt,
      mediaAttributes: mediaAttributes ?? this.mediaAttributes,
      stepsAttributes: stepsAttributes ?? this.stepsAttributes,
      hashtags: hashtags ?? this.hashtags,
      hobbies: hobbies ?? this.hobbies,
      owner: owner ?? this.owner,
      latestComment: latestComment ?? this.latestComment,
      mentionedUsers: mentionedUsers ?? this.mentionedUsers,
      level: level ?? this.level,
    );
  }
}
