import 'package:hauui_flutter/core/extensions/map_extensions.dart';
import 'package:hauui_flutter/core/models/hashtag_model.dart';
import 'package:hauui_flutter/core/models/media_model.dart';

import 'hobby_level_identifiers_model.dart';

class EventRequestBody {
  final String? title;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;

  final String? timezone;
  final String? address;
  final String? addressDetails;
  final double? lat;
  final double? long;
  final String? location;
  final String? website;
  final List<MediaModel>? mediaAttributes;
  final List<HobbyLevelIdentifiersModel>? hobbies;
  final List<HashtagModel>? hashtags;

  EventRequestBody({
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.timezone,
    this.address,
    this.addressDetails,
    this.lat,
    this.long,
    this.location,
    this.website,
    this.mediaAttributes,
    this.hobbies,
    this.hashtags,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "start_date": startDate?.toString(),
        "end_date": endDate?.toString(),
        "timezone": timezone,
        "address": address,
        "address_details": addressDetails,
        "lat": lat,
        "long": long,
        "location": location,
        "website": website,
        "media_attributes":
            mediaAttributes == null ? null : List<dynamic>.from(mediaAttributes!.map((media) => media.toJson())),
        "hobbies": hobbies == null ? null : List<dynamic>.from(hobbies!.map((hobby) => hobby.toJson())),
        "hashtags": hashtags == null ? null : List<dynamic>.from(hashtags!.map((hashtag) => hashtag.toJson())),
      }..removeNullValues();
}
