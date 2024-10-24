import 'package:hauui_flutter/core/models/data_file_model.dart';

class PresignedUrlRequestBody {
  List<DataFileModel>? dataFiles;

  PresignedUrlRequestBody({
    this.dataFiles,
  });

  PresignedUrlRequestBody.fromJson(dynamic json) {
    if (json['files'] != null) {
      dataFiles = [];
      json['files'].forEach((v) {
        dataFiles?.add(DataFileModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (dataFiles != null) {
      map['files'] = dataFiles?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
