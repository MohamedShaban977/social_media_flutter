import 'package:hauui_flutter/core/extensions/map_extensions.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/api_manager.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/verification/data/models/verification_model.dart';

class VerificationService {
  final ApiManager _apiManager;

  VerificationService(this._apiManager);

  Future<BaseResponse<VerificationModel>> resendOtp({
    required int userId,
    String? countryCode,
    String? phoneNumber,
    String? email,
  }) async {
    final response = await _apiManager.put(
      ApiConstants.apiResendOTP(
        userId,
      ),
      queryParameters: {
        'resend_verification': true,
        'country_code': countryCode,
        'new_phone': phoneNumber,
        'new_email': email,
      }..removeNullValues(),
    );
    return BaseResponse.fromJson(
      response,
      (data) => VerificationModel.fromJson(
        data,
      ),
    );
  }

  Future<BaseResponse<UserModel>> verifyRegister({required String verificationCode, required int userId}) async {
    final response = await _apiManager.put(
      ApiConstants.apiVerifyOtp(userId),
      data: {"verification_code": verificationCode},
    );

    return BaseResponse.fromJson(
      response,
      (data) => UserModel.fromJson(data),
    );
  }
}
