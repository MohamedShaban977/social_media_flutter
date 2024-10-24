import 'package:hauui_flutter/core/extensions/map_extensions.dart';

class CheckUpdateModel {
  final double? latestBuildNumber;
  final bool? hasHigherVersion;
  final bool? shouldForceUpdate;

  CheckUpdateModel({
    this.latestBuildNumber,
    this.hasHigherVersion,
    this.shouldForceUpdate,
  });

  factory CheckUpdateModel.fromJson(Map<String, dynamic> json) => CheckUpdateModel(
        latestBuildNumber: json["latest_build_number"],
        hasHigherVersion: json["has_higher_version"],
        shouldForceUpdate: json["should_force_update"],
      );

  Map<String, dynamic> toJson() => {
        "latest_build_number": latestBuildNumber,
        "has_higher_version": hasHigherVersion,
        "should_force_update": shouldForceUpdate,
      }..removeNullValues();
}
