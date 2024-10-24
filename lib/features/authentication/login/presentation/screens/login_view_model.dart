import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/account_mode.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/extensions/bool_extensions.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/shared_pref_manager.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/account_view_model.dart';
import 'package:hauui_flutter/features/authentication/login/data/repositories/login_repository.dart';
import 'package:hauui_flutter/features/authentication/login/data/requests_bodies/login_request_body.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/bottom_sheet/layout_login_with_bottom_sheet.dart';

class LoginViewModel {
  static final disableLoginButtonByPhoneProvider = AutoDisposeStateProvider<bool>((ref) => true);
  static final disableLoginButtonByEmailProvider = AutoDisposeStateProvider<bool>((ref) => true);
  static final loginProvider = NotifierProvider<LoginNotifier, AsyncValue<BaseResponse<UserModel>>>(
    () => LoginNotifier(),
  );

  static void navigateToLoginScreen() {
    Navigator.pushReplacementNamed(
      navigatorKey.currentContext!,
      RoutesNames.mainLayoutRoute,
    );
    navigatorKey.currentContext!.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
  }
}

class LoginNotifier extends Notifier<AsyncValue<BaseResponse<UserModel>>> {
  @override
  AsyncValue<BaseResponse<UserModel>> build() => const AsyncValue.loading();

  Future<void> login(LoginRequestBody loginRequestBody) async {
    state = const AsyncValue.loading();

    final result = await getIt<LoginRepository>().login(loginRequestBody: loginRequestBody);

    result.fold(
      (error) => state = AsyncValue.error(
        HandleFailure.mapFailureToMsg(error),
        StackTrace.current,
      ),
      (response) {
        if (response.data != null && response.data?.token != null) {
          _cacheUserData(response.data!);
          _cacheUserToken(response.data!.token!);
        }
        state = AsyncValue.data(response);
      },
    );

    if (state.hasValue) {
      if (state.value != null && state.value!.success) {
        if (state.value!.data != null && state.value!.data!.verified.orFalse()) {
          ref.read(AccountViewModel.accountModeProvider.notifier).update(
                (state) => state = AccountMode.authorized,
              );

          Navigator.pushReplacementNamed(navigatorKey.currentContext!, RoutesNames.mainLayoutRoute);
        }
      }
    }
    if (state.hasError) {
      navigatorKey.currentContext!.showToast(message: state.error.toString());
    }
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
