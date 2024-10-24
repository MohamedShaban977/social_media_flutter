import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/account_mode.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/managers/shared_pref_manager.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/account_view_model.dart';
import 'package:hauui_flutter/features/authentication/verification/data/models/verification_route_model.dart';
import 'package:hauui_flutter/features/authentication/verification/data/repositories/verification_repository.dart';

class VerificationViewModel {
  static final disableVerificationButtonProvider = AutoDisposeStateProvider<bool>((ref) => true);

  static void navigateToVerificationScreen(VerificationRouteModel verificationRouteModel) {
    Navigator.pushNamed(
      navigatorKey.currentContext!,
      RoutesNames.verificationRoute,
      arguments: {
        AppConstants.routeVerificationKey: verificationRouteModel.toJson(),
      },
    );
  }

  static final verifyRegisterProvider = NotifierProvider<VerifyRegisterNotifier, AsyncValue<BaseResponse<UserModel>>>(
    () => VerifyRegisterNotifier(),
  );

  Future<void> resendOtp({
    required int userId,
    String? countryCode,
    String? phoneNumber,
    String? email,
    required void Function(String) onSuccess,
    required void Function(String) onFail,
  }) async {
    final response = await getIt<VerificationRepository>().resendOtp(
      userId: userId,
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      email: email,
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
        onSuccess(
          email == null ? '${response.data?.verificationCode}' : '${response.data?.message}',
        );
      },
    );
  }
}

class VerifyRegisterNotifier extends Notifier<AsyncValue<BaseResponse<UserModel>>> {
  @override
  AsyncValue<BaseResponse<UserModel>> build() => const AsyncValue.loading();

  Future<void> verifyRegister({required String verificationCode, required int userId}) async {
    state = const AsyncValue.loading();

    final result = await getIt<VerificationRepository>().verifyRegister(
      userId: userId,
      verificationCode: verificationCode,
    );

    result.fold(
      (error) => state = AsyncValue.error(
        HandleFailure.mapFailureToMsg(error),
        StackTrace.current,
      ),
      (response) {
        if (response.data != null && response.data?.token != null) {
          _cacheUserData(response.data!);
          _cacheUserToken(response.data!.token!);
          ref.read(AccountViewModel.accountModeProvider.notifier).update(
                (state) => state = AccountMode.authorized,
              );
        }
        state = AsyncValue.data(response);
      },
    );
  }

  Future<void> _cacheUserData(UserModel data) async {
    await SharedPreferencesManager.saveData(
      key: AppConstants.prefKeyUser,
      value: json.encode(UserModel.fromJson(data.toJson())),
    );
  }

  Future<void> _cacheUserToken(String token) async {
    await SharedPreferencesManager.saveData(
      key: AppConstants.prefKeyAccessToken,
      value: token,
    );
  }
}
