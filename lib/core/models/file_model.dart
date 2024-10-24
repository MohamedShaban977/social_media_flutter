import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/enums/file_type.dart';
import 'package:hauui_flutter/core/managers/file_manager.dart';
import 'package:mime/mime.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class FileModel {
  String? identifier;
  String? name;
  Uint8List? bytes;
  Uint8List? thumbnail;
  File? pickedFile;
  int? originalWidth;
  int? originalHeight;
  FileType? fileType;

  FileModel({
    this.identifier,
    this.name,
    this.pickedFile,
    this.bytes,
    this.thumbnail,
    this.originalHeight,
    this.originalWidth,
    this.fileType,
  });

  static Future<List<FileModel>> fromAssetEntity({required List<AssetEntity> assetEntityList}) async {
    List<FileModel> fileModels = [];
    Uint8List? bytes;
    String? mimeType;
    Uint8List? thumbnail;
    FileType? fileType;
    for (AssetEntity assetEntity in assetEntityList) {
      final originalFile = await assetEntity.file;
      if (originalFile != null) {
        mimeType = lookupMimeType(originalFile.path);
        if (mimeType?.contains(AppConstants.image) == true) {
          fileType = FileType.image;
          bytes = await assetEntity.originBytes;
        } else if (mimeType?.contains(AppConstants.video) == true) {
          fileType = FileType.video;
          thumbnail = await assetEntity.thumbnailData;
        }

        fileType = (mimeType?.contains(AppConstants.image) == true)
            ? FileType.image
            : (mimeType?.contains(AppConstants.video) == true)
                ? FileType.video
                : null;
      }

      fileModels.add(FileModel(
        name: originalFile != null ? FileManager.getFileName(originalFile.path) : '',
        pickedFile: originalFile,
        bytes: bytes,
        thumbnail: thumbnail,
        fileType: fileType,
        identifier: "",
        originalHeight: assetEntity.orientatedHeight,
        originalWidth: assetEntity.orientatedWidth,
      ));
    }

    return fileModels;
  }
}
