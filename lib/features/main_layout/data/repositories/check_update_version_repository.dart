import 'package:dartz/dartz.dart';
import 'package:hauui_flutter/core/errors/exceptions.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/main_layout/data/models/check_update_model.dart';
import 'package:hauui_flutter/features/main_layout/data/services/check_update_version_service.dart';

class CheckUpdateVersionRepository {
  final CheckUpdateVersionService _checkUpdateVersionService;

  CheckUpdateVersionRepository(this._checkUpdateVersionService);

  Future<Either<Failure, BaseResponse<CheckUpdateModel>>> checkUpdateVersion({
    required String platform,
    required String buildNumber,
  }) async {
    try {
      final response = await _checkUpdateVersionService.checkUpdateVersion(platform, buildNumber);

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }
}
