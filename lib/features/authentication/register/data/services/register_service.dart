import 'package:hauui_flutter/core/constants/enums/user_existence_verification.dart';
import 'package:hauui_flutter/core/models/success_message_model.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/api_manager.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/register/data/requests_bodies/check_user_exists_request_body.dart';
import 'package:hauui_flutter/features/authentication/register/data/requests_bodies/register_request_body.dart';

class RegisterService {
  final ApiManager _apiManager;

  RegisterService(this._apiManager);

  Future<BaseResponse<SuccessMessageModel>> checkIfUserExists({
    required UserExistenceVerification userExistenceVerification,
    required CheckUserExistsRequestBody checkUserExistsRequestBody,
  }) async {
    final response = await _apiManager.post(
      ApiConstants.apiCheckUserExists,
      queryParameters: {
        'find_by': userExistenceVerification.key,
      },
      data: checkUserExistsRequestBody.toJson(),
    );

    return BaseResponse.fromJson(
      response,
      (data) => SuccessMessageModel.fromJson(
        data,
      ),
    );
  }

  Future<BaseResponse<UserModel>> register({required RegisterRequestBody registerRequestBody}) async {
    final response = await _apiManager.post(
      ApiConstants.apiRegister,
      data: registerRequestBody.toJson(),
    );

    return BaseResponse.fromJson(
      response,
      (data) => UserModel.fromJson(data),
    );
  }
}
