import 'package:hauui_flutter/core/extensions/map_extensions.dart';

class CityModel {
  final int? id;
  final String? name;
  final int? countryId;
  final String? countryName;

  CityModel({
    this.id,
    this.name,
    this.countryId,
    this.countryName,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        id: json["id"],
        name: json["name"],
        countryId: json["country_id"],
        countryName: json["country_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country_id": countryId,
        "country_name": countryName,
      }..removeNullValues();
}
