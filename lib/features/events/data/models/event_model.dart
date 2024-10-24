import 'package:hauui_flutter/core/models/city_model.dart';
import 'package:hauui_flutter/core/models/hashtag_model.dart';
import 'package:hauui_flutter/core/models/hobby_level_model.dart';
import 'package:hauui_flutter/core/models/hobby_model.dart';
import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/core/models/level_model.dart';
import 'package:hauui_flutter/core/models/media_model.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/utils/json_util.dart';

class EventModel {
  final int? id;
  final String? title;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? address;
  final String? addressDetails;
  final String? location;
  final String? timezone;
  final String? dynamicLink;
  final double? lat;
  final double? long;
  final String? website;
  final DateTime? createdAt;
  final List<MediaModel>? mediaAttribute;
  final List<HobbyLevelModel>? hobbies;
  final List<HashtagModel>? hashtags;
  final UserModel? owner;
  int? joinersCount;
  bool? isJoined;
  bool? isSaved;
  final bool? isOwner;
  final List<UserModel>? latestJoiners;
  final HobbyModel? hobby;
  final LevelModel? level;
  final CityModel? city;
  final IntKeyStingValueModel? country;

  EventModel({
    this.id,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.address,
    this.addressDetails,
    this.location,
    this.timezone,
    this.dynamicLink,
    this.lat,
    this.long,
    this.website,
    this.createdAt,
    this.mediaAttribute,
    this.hobbies,
    this.hashtags,
    this.owner,
    this.joinersCount,
    this.isJoined,
    this.isSaved,
    this.isOwner,
    this.latestJoiners,
    this.hobby,
    this.level,
    this.city,
    this.country,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        address: json["address"],
        addressDetails: json["address_details"],
        location: json["location"],
        timezone: json["timezone"],
        dynamicLink: json["dynamic_link"],
        joinersCount: json["joiners_count"],
        isJoined: json["is_joined"],
        isSaved: json["is_saved"],
        isOwner: json["is_owner"],
        startDate: JsonUtil.convertEmptyToNull(
          json['start_date'],
          (data) => JsonUtil.deserializeObject(
            data,
            (element) => DateTime.parse(element),
          ),
        ),
        endDate: JsonUtil.convertEmptyToNull(
          json['end_date'],
          (jsonData) => JsonUtil.deserializeObject(
            jsonData,
            (data) => DateTime.parse(data),
          ),
        ),
        lat: json["lat"]?.toDouble(),
        long: json["long"]?.toDouble(),
        mediaAttribute: JsonUtil.deserializeList(json['media_attributes'], (data) => MediaModel.fromJson(data)),
        hobbies: JsonUtil.deserializeList(json['hobbies'], (data) => HobbyLevelModel.fromJson(data)),
        website: json["website"],
        createdAt: JsonUtil.convertEmptyToNull(
          json['created_at'],
          (data) => JsonUtil.deserializeObject(
            data,
            (element) => DateTime.parse(element),
          ),
        ),
        latestJoiners: JsonUtil.deserializeList(json['latest_joiners'], (data) => UserModel.fromJson(data)),
        hashtags: JsonUtil.deserializeList(json['hashtags'], (data) => HashtagModel.fromJson(data)),
        owner: JsonUtil.deserializeObject(json['owner'], (data) => UserModel.fromJson(data)),
        hobby: JsonUtil.deserializeObject(json['hobby'], (data) => HobbyModel.fromJson(data)),
        level: JsonUtil.deserializeObject(json['level'], (data) => LevelModel.fromJson(data)),
        city: JsonUtil.deserializeObject(json['city'], (data) => CityModel.fromJson(data)),
        country: JsonUtil.deserializeObject(json['country'], (data) => IntKeyStingValueModel.fromJson(data)),
      );
}
