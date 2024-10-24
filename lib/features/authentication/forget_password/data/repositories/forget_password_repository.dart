import 'package:dartz/dartz.dart';
import 'package:hauui_flutter/core/errors/exceptions.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/forget_password/data/requests_bodies/confirmed_password_request_body.dart';
import 'package:hauui_flutter/features/authentication/forget_password/data/requests_bodies/forget_password_request_body.dart';
import 'package:hauui_flutter/features/authentication/forget_password/data/services/forget_password_service.dart';
import 'package:hauui_flutter/features/authentication/verification/data/models/verification_model.dart';

class ForgetPasswordRepository {
  final ForgetPasswordService _forgetPasswordService;

  ForgetPasswordRepository(this._forgetPasswordService);

  Future<Either<Failure, BaseResponse<VerificationModel>>> forgetPassword(
      {required ForgetPasswordRequestBody forgetPasswordRequestBody}) async {
    try {
      final response = await _forgetPasswordService.forgetPassword(forgetPasswordBody: forgetPasswordRequestBody);

      return (response.success) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }

  Future<Either<Failure, BaseResponse<VerificationModel>>> verifyForgetPasswordOTP({
    required String resetPasswordCode,
  }) async {
    try {
      final response = await _forgetPasswordService.verifyForgetPasswordOTP(
        resetPasswordCode: resetPasswordCode,
      );
      return (response.success)
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

  Future<Either<Failure, BaseResponse<VerificationModel>>> changePasswordByResetPassword({
    required String resetPasswordCode,
    required ConfirmedPasswordRequestBody confirmedPasswordRequestBody,
  }) async {
    try {
      final response = await _forgetPasswordService.changePasswordByResetPassword(
        confirmedPasswordRequestBody: confirmedPasswordRequestBody,
        resetPasswordCode: resetPasswordCode,
      );

      return (response.success) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }
}
