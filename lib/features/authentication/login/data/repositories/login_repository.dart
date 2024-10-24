import 'package:dartz/dartz.dart';
import 'package:hauui_flutter/core/errors/exceptions.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/login/data/requests_bodies/login_request_body.dart';
import 'package:hauui_flutter/features/authentication/login/data/services/login_service.dart';

class LoginRepository {
  final LoginService _loginService;

  LoginRepository(this._loginService);

  Future<Either<Failure, BaseResponse<UserModel>>> login({required LoginRequestBody loginRequestBody}) async {
    try {
      final response = await _loginService.login(loginRequestBody: loginRequestBody);

      return (response.success && response.data != null) ? Right(response) : left(ServerFailure(response.message));
    } on ServerException catch (error) {
      return left(ServerFailure(error.message));
    }
  }
}
