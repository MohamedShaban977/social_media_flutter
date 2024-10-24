import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/file_type.dart';
import 'package:hauui_flutter/core/constants/enums/upload_status.dart';
import 'package:hauui_flutter/core/models/data_file_model.dart';
import 'package:hauui_flutter/core/models/file_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/api_manager.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/core/network/status_code.dart';
import 'package:hauui_flutter/core/requests_bodies/presigned_url_request_body.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class S3Service {
  S3Service(this._apiManager);

  final ApiManager _apiManager;

  Future<BaseCollectionResponse<DataFileModel>> getPreSignedUrls({
    required PresignedUrlRequestBody presignedUrlRequestBody,
  }) async {
    final response = await _apiManager.post(
      ApiConstants.apiGeneratePresignedUrl,
      data: presignedUrlRequestBody.toJson(),
    );

    return BaseCollectionResponse.fromJson(
      response,
      (item) => DataFileModel.fromJson(item),
    );
  }

  Future<UploadStatus> uploadToS3({
    required DataFileModel dataFile,
    required File? file,
    required String extension,
    required void Function(double) onProgress,
    required List<FileModel> files,
    required int index,
  }) async {
    final dio = getIt<Dio>(instanceName: AppConstants.instanceNameDioS3);

    if (kDebugMode) {
      dio.interceptors.add(getIt<PrettyDioLogger>());
    }
    final response = await dio.put(
      dataFile.preSignedUrl!,
      data: file?.openRead(),
      options: Options(
        contentType: FileTypeExtensions.tryParse(extension)?.mime,
        headers: {
          "Content-Type": "application/octet-stream",
          "Content-Length": file?.lengthSync(),
        },
      ),
      onSendProgress: (sent, total) {
        double progressPercent = sent / total * 100;
        if (files.length > 1) {
          progressPercent = ((index + 1) / files.length) * 100;
        }
        onProgress.call(progressPercent);
        logger.i(
          '${dataFile.fileName} ${progressPercent.toStringAsFixed(
            0,
          )} %',
        );
      },
    );

    if (response.statusCode == StatusCode.ok) {
      return UploadStatus.complete;
    } else {
      return UploadStatus.failed;
    }
  }
}
