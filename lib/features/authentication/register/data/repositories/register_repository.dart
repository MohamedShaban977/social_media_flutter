import 'package:dartz/dartz.dart';
import 'package:hauui_flutter/core/constants/enums/user_existence_verification.dart';
import 'package:hauui_flutter/core/errors/exceptions.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/success_message_model.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/register/data/requests_bodies/check_user_exists_request_body.dart';
import 'package:hauui_flutter/features/authentication/register/data/requests_bodies/register_request_body.dart';
import 'package:hauui_flutter/features/authentication/register/data/services/register_service.dart';

class RegisterRepository {
  final RegisterService _registerService;

  RegisterRepository(this._registerService);

  Future<Either<Failure, BaseResponse<SuccessMessageModel>>> checkIfUserExists({
    required UserExistenceVerification userExistenceVerification,
    required CheckUserExistsRequestBody checkUserExistsRequestBody,
  }) async {
    try {
      final response = await _registerService.checkIfUserExists(
        userExistenceVerification: userExistenceVerification,
        checkUserExistsRequestBody: checkUserExistsRequestBody,
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

  Future<Either<Failure, BaseResponse<UserModel>>> register({required RegisterRequestBody registerRequestBody}) async {
    try {
      final response = await _registerService.register(registerRequestBody: registerRequestBody);

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }
}
