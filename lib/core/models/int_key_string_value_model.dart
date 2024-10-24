import 'package:hauui_flutter/core/extensions/map_extensions.dart';

class IntKeyStingValueModel {
  int? id;
  String? name;

  IntKeyStingValueModel({
    this.id,
    this.name,
  });

  IntKeyStingValueModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    }..removeNullValues();
  }
}
