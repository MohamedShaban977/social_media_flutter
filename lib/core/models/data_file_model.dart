class DataFileModel {
  String? extension;
  String? preSignedUrl;
  String? fileUrl;
  String? fileName;

  DataFileModel({
    this.extension,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['extension'] = extension;
    return map;
  }

  DataFileModel.fromJson(dynamic json) {
    extension = json['extension'];
    extension = json['extension'];
    preSignedUrl = json['presigned_url'];
    fileUrl = json['file_url'];
    fileName = json['file_name'];
  }
}
