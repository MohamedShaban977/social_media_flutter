import 'dart:convert';

import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/managers/shared_pref_manager.dart';
import 'package:hauui_flutter/core/utils/json_util.dart';

import 'city_model.dart';
import 'rank_model.dart';

class UserModel {
  final int? id;
  final String? name;
  final String? countryCode;
  final String? phoneNumber;
  final String? email;
  final String? gender;
  final String? birthdate;
  final double? lat;
  final double? long;
  final double? totalRate;
  final RankModel? rank;
  final String? verificationCode;
  final bool? notificationsEnabled;
  final String? locale;
  final String? imageUrl;
  final int? hobbiesCount;
  int? followersCount;
  final int? followingsCount;
  final String? newEmail;
  final String? newCountryCode;
  final String? newPhone;
  final bool? seeFirst;
  final String? lang;
  final bool? verified;
  bool? isFollowed;
  final bool? isReviewed;
  final String? verifyBy;
  final String? addressDetails;
  final String? firebaseToken;
  final String? firebaseNodeUrl;
  final String? token;
  final CityModel? city;

  UserModel({
    this.id,
    this.name,
    this.countryCode,
    this.phoneNumber,
    this.email,
    this.gender,
    this.birthdate,
    this.lat,
    this.long,
    this.totalRate,
    this.rank,
    this.verificationCode,
    this.notificationsEnabled,
    this.locale,
    this.imageUrl,
    this.hobbiesCount,
    this.followersCount,
    this.followingsCount,
    this.newEmail,
    this.newCountryCode,
    this.newPhone,
    this.seeFirst,
    this.lang,
    this.verified,
    this.isFollowed,
    this.isReviewed,
    this.verifyBy,
    this.addressDetails,
    this.firebaseToken,
    this.firebaseNodeUrl,
    this.token,
    this.city,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      name: json["name"],
      countryCode: json["country_code"],
      phoneNumber: json["phone_number"],
      email: json["email"],
      gender: json["gender"],
      birthdate: json["birthdate"],
      lat: json["lat"],
      long: json["long"],
      totalRate: json["total_rate"],
      rank: JsonUtil.deserializeObject(json["rank"], (data) => RankModel.fromJson(data)),
      verificationCode: json["verification_code"],
      notificationsEnabled: json["notifications_enabled"],
      locale: json["locale"],
      imageUrl: json["image_url"],
      hobbiesCount: json["hobbies_count"],
      followersCount: json["followers_count"],
      followingsCount: json["followings_count"],
      isFollowed: json["is_followed"],
      isReviewed: json["is_reviewed"],
      newEmail: json["new_email"],
      newCountryCode: json["new_country_code"],
      newPhone: json["new_phone"],
      seeFirst: json["see_first"],
      lang: json["lang"],
      verified: json["verified"],
      verifyBy: json["verify_by"],
      addressDetails: json["address_details"],
      firebaseToken: json["firebase_token"],
      firebaseNodeUrl: json["firebase_node_url"],
      token: json["token"],
      city: JsonUtil.deserializeObject(json["city"], (data) => CityModel.fromJson(data)));

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country_code": countryCode,
        "phone_number": phoneNumber,
        "email": email,
        "gender": gender,
        "birthdate": birthdate,
        "lat": lat,
        "long": long,
        "total_rate": totalRate,
        "rank": rank?.toJson(),
        "verification_code": verificationCode,
        "notifications_enabled": notificationsEnabled,
        "locale": locale,
        "image_url": imageUrl,
        "hobbies_count": hobbiesCount,
        "followers_count": followersCount,
        "followings_count": followingsCount,
        "new_email": newEmail,
        "new_country_code": newCountryCode,
        "new_phone": newPhone,
        "see_first": seeFirst,
        "lang": lang,
        "verified": verified,
        "verify_by": verifyBy,
        "address_details": addressDetails,
        "firebase_token": firebaseToken,
        "firebase_node_url": firebaseNodeUrl,
        "token": token,
        "city": city?.toJson(),
      };
}

extension UserExtensions on UserModel {
  static UserModel? getCachedUser() {
    final cachedUser = SharedPreferencesManager.getData(
      key: AppConstants.prefKeyUser,
    );
    if (cachedUser != null) {
      return JsonUtil.deserializeObject(
        json.decode(
          cachedUser,
        ),
        (data) => UserModel.fromJson(
          data,
        ),
      );
    } else {
      return null;
    }
  }
}
