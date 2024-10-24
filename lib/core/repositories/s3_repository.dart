import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/upload_status.dart';
import 'package:hauui_flutter/core/errors/exceptions.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/data_file_model.dart';
import 'package:hauui_flutter/core/models/file_model.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/core/requests_bodies/presigned_url_request_body.dart';
import 'package:hauui_flutter/core/services/s3_service.dart';

class S3Repository {
  final S3Service _s3Service;

  S3Repository(this._s3Service);

  Future<Either<Failure, BaseCollectionResponse<DataFileModel>>> getPreSignedUrls({
    required PresignedUrlRequestBody presignedUrlRequestBody,
  }) async {
    try {
      final response = await _s3Service.getPreSignedUrls(presignedUrlRequestBody: presignedUrlRequestBody);

      return response.success ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<UploadStatus> uploadToS3({
    required DataFileModel dataFile,
    required File? file,
    required String extension,
    required void Function(double progress) onProgress,
    required List<FileModel> files,
    required int index,
  }) async {
    try {
      final uploadStatus = await _s3Service.uploadToS3(
        dataFile: dataFile,
        file: file,
        extension: extension,
        onProgress: onProgress,
        files: files,
        index: index,
      );
      logger.i('File is uploaded successfully');
      return uploadStatus;
    } catch (e) {
      logger.e('Failed to upload file: ${e.toString()}');
      index--;
      return UploadStatus.failed;
    }
  }
}
