import 'package:hauui_flutter/core/extensions/map_extensions.dart';

class TimezoneModel {
  final String? key;
  final String? value;

  TimezoneModel({
    this.key,
    this.value,
  });

  factory TimezoneModel.fromJson(Map<String, dynamic> json) => TimezoneModel(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      }..removeNullValues();
}
