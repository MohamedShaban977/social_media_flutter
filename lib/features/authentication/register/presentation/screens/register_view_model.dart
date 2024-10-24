import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/user_existence_verification.dart';
import 'package:hauui_flutter/core/constants/enums/verify_by.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/managers/shared_pref_manager.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/authentication/register/data/repositories/register_repository.dart';
import 'package:hauui_flutter/features/authentication/register/data/requests_bodies/check_user_exists_request_body.dart';
import 'package:hauui_flutter/features/authentication/register/data/requests_bodies/register_request_body.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class RegisterViewModel {
  static final indexScreenProvider = StateProvider<int>((ref) => 0);
  static final disableButtonByNameProvider = StateProvider<bool>((ref) => true);
  static final disableButtonByPhoneProvider = StateProvider<bool>((ref) => true);
  static final disableButtonByEmailProvider = StateProvider<bool>((ref) => true);
  static final disableButtonByPasswordProvider = StateProvider<bool>((ref) => true);
  static final verifyByProvider = StateProvider<VerifyBy>((ref) => VerifyBy.sms);

  static final registerProvider = StateNotifierProvider<RegisterNotifier, AsyncValue<BaseResponse<UserModel>>>((ref) {
    return RegisterNotifier(const AsyncValue.loading());
  });

  Future<void> checkIfUserExists({
    required UserExistenceVerification userExistenceVerification,
    required CheckUserExistsRequestBody checkUserExistsRequestBody,
    required void Function(String) onSuccess,
    required void Function(String) onFail,
  }) async {
    final response = await getIt<RegisterRepository>().checkIfUserExists(
      userExistenceVerification: userExistenceVerification,
      checkUserExistsRequestBody: checkUserExistsRequestBody,
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
          userExistenceVerification == UserExistenceVerification.phone
              ? LocaleKeys.phoneAlreadyExists.tr()
              : LocaleKeys.emailAlreadyExists.tr(),
        );
      },
    );
  }
}

class RegisterNotifier extends StateNotifier<AsyncValue<BaseResponse<UserModel>>> {
  RegisterNotifier(super._state);

  Future<void> register(RegisterRequestBody registerRequestBody) async {
    state = const AsyncValue.loading();

    final result = await getIt<RegisterRepository>().register(registerRequestBody: registerRequestBody);

    result.fold(
      (error) => state = AsyncValue.error(
        HandleFailure.mapFailureToMsg(error),
        StackTrace.current,
      ),
      (response) {
        if (response.data != null && response.data?.token != null) {
          _cacheUserToken(response.data!.token!);
        }
        state = AsyncValue.data(response);
      },
    );
  }

  Future<void> _cacheUserToken(String token) async {
    await SharedPreferencesManager.saveData(
      key: AppConstants.prefKeyAccessToken,
      value: token,
    );
  }
}
