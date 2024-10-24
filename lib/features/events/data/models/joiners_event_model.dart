import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/utils/json_util.dart';

class JoinersEventModel {
  List<UserModel>? joiners;
  final int? totalCount;

  JoinersEventModel({
    this.joiners,
    this.totalCount,
  });

  factory JoinersEventModel.fromJson(Map<String, dynamic> json) => JoinersEventModel(
        joiners: JsonUtil.deserializeList(json['attendees'], (data) => UserModel.fromJson(data)),
        totalCount: json["total_count"],
      );
}
