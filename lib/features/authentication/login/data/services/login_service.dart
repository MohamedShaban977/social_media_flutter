import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/api_manager.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/login/data/requests_bodies/login_request_body.dart';

class LoginService {
  final ApiManager _apiManager;

  LoginService(this._apiManager);

  Future<BaseResponse<UserModel>> login({required LoginRequestBody loginRequestBody}) async {
    final response = await _apiManager.post(
      ApiConstants.apiLogin,
      data: loginRequestBody.toJson(),
    );

    return BaseResponse.fromJson(
      response,
      (data) => UserModel.fromJson(data),
    );
  }
}
