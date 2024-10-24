import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/api_manager.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/forget_password/data/requests_bodies/confirmed_password_request_body.dart';
import 'package:hauui_flutter/features/authentication/forget_password/data/requests_bodies/forget_password_request_body.dart';
import 'package:hauui_flutter/features/authentication/verification/data/models/verification_model.dart';

class ForgetPasswordService {
  final ApiManager _apiManager;

  ForgetPasswordService(this._apiManager);

  Future<BaseResponse<VerificationModel>> forgetPassword(
      {required ForgetPasswordRequestBody forgetPasswordBody}) async {
    final response = await _apiManager.post(
      ApiConstants.apiForgetPassword,
      data: forgetPasswordBody.toJson(),
    );

    return BaseResponse.fromJson(response, (data) => VerificationModel.fromJson(data));
  }

  Future<BaseResponse<VerificationModel>> verifyForgetPasswordOTP({
    required String resetPasswordCode,
  }) async {
    final response = await _apiManager.put(
      ApiConstants.apiVerifyForgetPasswordOTP(
        resetPasswordCode,
      ),
    );
    return BaseResponse.fromJson(
      response,
      (data) => VerificationModel.fromJson(
        data,
      ),
    );
  }

  Future<BaseResponse<VerificationModel>> changePasswordByResetPassword({
    required String resetPasswordCode,
    required ConfirmedPasswordRequestBody confirmedPasswordRequestBody,
  }) async {
    final response = await _apiManager.put(
      '${ApiConstants.apiForgetPassword}/$resetPasswordCode',
      data: confirmedPasswordRequestBody.toJson(),
    );

    return BaseResponse.fromJson(response, (data) => VerificationModel.fromJson(data));
  }
}
