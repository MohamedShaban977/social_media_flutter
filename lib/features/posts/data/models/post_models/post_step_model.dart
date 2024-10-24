import 'package:hauui_flutter/core/models/media_model.dart';
import 'package:hauui_flutter/core/utils/json_util.dart';

class PostStepModel {
  int? id;
  int? stepNo;
  String? title;
  String? body;
  DateTime? createdAt;
  List<MediaModel>? mediaAttributes;

  PostStepModel({
    this.id,
    this.stepNo,
    this.title,
    this.body,
    this.createdAt,
    this.mediaAttributes,
  });

  PostStepModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stepNo = json['step_no'];
    title = json['title'];
    body = json['body'];
    createdAt = JsonUtil.deserializeObject(json['created_at'], (element) => DateTime.parse(element));
    mediaAttributes = JsonUtil.deserializeList(json['media_attributes'], (data) => MediaModel.fromJson(data));
  }
}
