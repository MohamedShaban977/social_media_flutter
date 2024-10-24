import 'package:hauui_flutter/core/extensions/map_extensions.dart';
import 'package:hauui_flutter/core/models/hashtag_model.dart';
import 'package:hauui_flutter/core/models/media_model.dart';

import 'hobby_level_identifiers_model.dart';

class EditEventRequestBody {
  final int? levelId;
  final String? description;
  final double? lat;
  final int? location;
  final double? long;
  final String? website;
  final DateTime? startDate;
  final String? title;
  final String? timezone;
  final List<HobbyLevelIdentifiersModel>? hobbies;
  final List<MediaModel>? mediaAttributes;
  final List<HashtagModel>? hashtags;
  final String? addressDetails;
  final String? address;

  EditEventRequestBody({
    this.levelId,
    this.description,
    this.lat,
    this.location,
    this.long,
    this.website,
    this.startDate,
    this.title,
    this.timezone,
    this.hobbies,
    this.addressDetails,
    this.mediaAttributes,
    this.hashtags,
    this.address,
  });

  Map<String, dynamic> toJson() => {
        "level_id": levelId,
        "description": description,
        "lat": lat,
        "location": location,
        "long": long,
        "website": website,
        "start_date": startDate,
        "title": title,
        "timezone": timezone,
        "hobbies": hobbies == null ? [] : List<dynamic>.from(hobbies!.map((hobby) => hobby.toJson())),
        "media_attributes":
            mediaAttributes == null ? null : List<dynamic>.from(mediaAttributes!.map((media) => media.toJson())),
        "hashtags": hashtags == null ? null : List<dynamic>.from(hashtags!.map((hashtag) => hashtag.toJson())),
        "address_details": addressDetails,
        "address": address,
      }..removeNullValues();
}
