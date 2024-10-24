import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/forget_password/data/repositories/forget_password_repository.dart';
import 'package:hauui_flutter/features/authentication/forget_password/data/requests_bodies/confirmed_password_request_body.dart';
import 'package:hauui_flutter/features/authentication/forget_password/data/requests_bodies/forget_password_request_body.dart';
import 'package:hauui_flutter/features/authentication/verification/data/models/verification_model.dart';

class ForgetPasswordViewModel {
  static final disableSubmitButtonByPhoneProvider = StateProvider.autoDispose<bool>((ref) => true);
  static final disableSubmitButtonByEmailProvider = StateProvider.autoDispose<bool>((ref) => true);
  static final disableSubmitButtonBySetNewPasswordProvider = StateProvider<bool>((ref) => true);

  static final forgetPasswordProvider =
      StateNotifierProvider<ForgetPasswordNotifier, AsyncValue<BaseResponse<VerificationModel>>>(
    (ref) => ForgetPasswordNotifier(
      const AsyncValue.loading(),
    ),
  );

  static final changePasswordByResetPasswordProvider =
      StateNotifierProvider<ChangePasswordByResetPasswordNotifier, AsyncValue<BaseResponse<VerificationModel>>>(
    (ref) => ChangePasswordByResetPasswordNotifier(
      const AsyncValue.loading(),
    ),
  );

  static void navigateToSetNewPasswordScreen({required String resetPasswordCode}) {
    Navigator.pushNamed(
      navigatorKey.currentContext!,
      RoutesNames.setNewPasswordRoute,
      arguments: {
        AppConstants.routeSetNewPasswordKey: resetPasswordCode,
      },
    );
  }

  Future<void> verifyForgetPasswordOTP({
    required String resetPasswordCode,
    required void Function() onSuccess,
    required void Function(String) onFail,
  }) async {
    final response = await getIt<ForgetPasswordRepository>().verifyForgetPasswordOTP(
      resetPasswordCode: resetPasswordCode,
    );
    response.fold(
      (error) {
        onFail(
          HandleFailure.mapFailureToMsg(
            error,
          ),
        );
      },
      (response) {
        onSuccess();
      },
    );
  }
}

class ForgetPasswordNotifier extends StateNotifier<AsyncValue<BaseResponse<VerificationModel>>> {
  ForgetPasswordNotifier(super._state);

  Future<void> forgetPassword(ForgetPasswordRequestBody requestBody) async {
    state = const AsyncValue.loading();

    final result = await getIt<ForgetPasswordRepository>().forgetPassword(forgetPasswordRequestBody: requestBody);

    result.fold(
      (error) => state = AsyncValue.error(
        HandleFailure.mapFailureToMsg(error),
        StackTrace.current,
      ),
      (response) => state = AsyncValue.data(response),
    );
  }
}

class ChangePasswordByResetPasswordNotifier extends StateNotifier<AsyncValue<BaseResponse<VerificationModel>>> {
  ChangePasswordByResetPasswordNotifier(super._state);

  Future<void> changePasswordByResetPassword({required String resetPasswordCode, required String password}) async {
    state = const AsyncValue.loading();

    final result = await getIt<ForgetPasswordRepository>().changePasswordByResetPassword(
      confirmedPasswordRequestBody: ConfirmedPasswordRequestBody(
        password: password,
        confirmedPassword: password,
      ),
      resetPasswordCode: resetPasswordCode,
    );

    result.fold(
      (error) => state = AsyncValue.error(
        HandleFailure.mapFailureToMsg(error),
        StackTrace.current,
      ),
      (response) => state = AsyncValue.data(response),
    );
  }
}
