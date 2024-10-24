import 'package:dartz/dartz.dart';
import 'package:hauui_flutter/core/errors/exceptions.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/login/data/models/rank_model.dart';
import 'package:hauui_flutter/features/profile/data/services/profile_service.dart';

class ProfileRepository {
  final ProfileService _profileService;

  ProfileRepository(
    this._profileService,
  );

  Future<Either<Failure, BaseResponse<UserModel>>> getProfile({
    required int userId,
  }) async {
    try {
      final response = await _profileService.getProfile(
        userId: userId,
      );
      return response.success
          ? Right(
              response,
            )
          : left(
              ServerFailure(
                response.message,
              ),
            );
    } on ServerException catch (error) {
      return left(
        ServerFailure(
          error.message,
        ),
      );
    }
  }

  Future<Either<Failure, BaseCollectionResponse<RankModel>>> getRanks() async {
    try {
      final response = await _profileService.getRanks();
      return response.success
          ? Right(
              response,
            )
          : left(
              ServerFailure(
                response.message,
              ),
            );
    } on ServerException catch (error) {
      return left(
        ServerFailure(
          error.message,
        ),
      );
    }
  }
}
