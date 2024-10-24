import 'package:dartz/dartz.dart';
import 'package:hauui_flutter/core/errors/exceptions.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/verification/data/models/verification_model.dart';
import 'package:hauui_flutter/features/authentication/verification/data/services/verification_service.dart';

class VerificationRepository {
  final VerificationService _verificationService;

  VerificationRepository(this._verificationService);

  Future<Either<Failure, BaseResponse<VerificationModel>>> resendOtp({
    required int userId,
    String? countryCode,
    String? phoneNumber,
    String? email,
  }) async {
    try {
      final response = await _verificationService.resendOtp(
        userId: userId,
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        email: email,
      );
      return (response.success && response.data != null)
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

  Future<Either<Failure, BaseResponse<UserModel>>> verifyRegister(
      {required String verificationCode, required int userId}) async {
    try {
      final response = await _verificationService.verifyRegister(userId: userId, verificationCode: verificationCode);

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }
}
