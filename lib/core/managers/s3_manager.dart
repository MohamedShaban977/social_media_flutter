import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/file_manager.dart';
import 'package:hauui_flutter/core/models/data_file_model.dart';
import 'package:hauui_flutter/core/models/file_model.dart';
import 'package:hauui_flutter/core/repositories/s3_repository.dart';
import 'package:hauui_flutter/core/requests_bodies/presigned_url_request_body.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:mime/mime.dart';

class S3Manager {
  S3Manager();

  static Future<List<DataFileModel>> uploadToS3({
    required List<FileModel> files,
    required void Function(double progress) onProgress,
  }) async {
    String? mimeType;
    List<DataFileModel> dataFiles = [];

    final result = await getIt<S3Repository>().getPreSignedUrls(
      presignedUrlRequestBody: PresignedUrlRequestBody(
        dataFiles: files
            .map(
              (file) => DataFileModel(
                extension: FileManager.getFileExtension(file.name ?? ''),
              ),
            )
            .toList(),
      ),
    );

    result.fold((error) => navigatorKey.currentContext!.showToast(message: HandleFailure.mapFailureToMsg(error)),
        (response) async {
      if (response.data != null) {
        dataFiles = response.data!;

        if (response.success) {
          for (int i = 0; i < files.length; i++) {
            File? file;
            if (navigatorKey.currentContext!.mounted && files[i].name == null) {
              navigatorKey.currentContext!.showToast(
                message: LocaleKeys.failedToUploadSomeFiles.tr(),
              );
              break;
            }
            final extension = FileManager.getFileExtension(files[i].name!);

            if (files[i].pickedFile != null) {
              mimeType = lookupMimeType(files[i].pickedFile!.path);
            }

            /// if this mimeType image
            if (mimeType != null && mimeType!.contains(AppConstants.image)) {
              Uint8List imageData = await FileManager.compressImage(files[i].bytes);
              file = await FileManager.toFile(imageData, files[i].name);
            } else {
              file = files[i].pickedFile;
            }
            await getIt<S3Repository>().uploadToS3(
              dataFile: dataFiles[i],
              file: file,
              extension: extension,
              onProgress: onProgress,
              files: files,
              index: i,
            );
          }
        }
      }
    });
    return dataFiles;
  }

  static Future<String> downloadFromS3({
    required BuildContext context,
    required String url,
    String? prefix,
    String? postfix,
    String? errorMessage,
  }) async {
    final file = await DefaultCacheManager().getSingleFile(
      url,
    );
    final xFile = XFile(
      file.path,
    );
    final saveName = FileManager.generateFileName(
      prefix: prefix,
      postfix: postfix,
    );
    final bytes = await xFile.readAsBytes();
    final savePath = await FileSaver.instance.saveAs(
      name: saveName,
      bytes: bytes,
      ext: xFile.path.split('.').last,
      mimeType: MimeType.values.firstWhere(
        (mimeType) => mimeType.type == xFile.mimeType,
        orElse: () => MimeType.other,
      ),
    );
    if (savePath != null) {
      return LocaleKeys.fileIsDownloadedSuccessfully.tr();
    } else {
      return LocaleKeys.failedToDownloadFile.tr();
    }
  }
}
