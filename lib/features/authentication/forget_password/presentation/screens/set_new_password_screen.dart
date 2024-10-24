import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/shared_pref_manager.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/label_screen_widget.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/password_input_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_button_with_loading_widget.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/screens/login_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

import 'forget_password_view_model.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key, required this.resetPasswordCode});

  final String resetPasswordCode;

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final passwordController = TextEditingController();
  final ValueNotifier<bool> _isVisiblePassword = ValueNotifier(true);

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    _isVisiblePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.maybePop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: AppDimens.spacingXLarge,
                ),
                child: LabelScreenWidget(
                  title: LocaleKeys.setNewPassword.tr(),
                  isAxisVirtual: true,
                  sizeIcon: AppDimens.widgetDimen45pt,
                  sizeTitle: AppDimens.textSize24pt,
                ),
              ),
              SizedBox(
                height: context.height * 0.15,
              ),
              Consumer(
                builder: (context, provider, child) {
                  return Form(
                    key: _formKey,
                    onChanged: () => provider
                        .read(ForgetPasswordViewModel.disableSubmitButtonBySetNewPasswordProvider.notifier)
                        .state = !(_formKey.currentState!.validate()),
                    child: PasswordInputWidget(
                      passwordController: passwordController,
                      label: LocaleKeys.newPassword.tr(),
                      isVisiblePassword: _isVisiblePassword,
                      showValidation: true,
                    ),
                  );
                },
              ),
              const SizedBox(height: AppDimens.widgetDimen32pt),
              Consumer(
                builder: (context, provider, child) {
                  final disableBtn =
                      provider.watch(ForgetPasswordViewModel.disableSubmitButtonBySetNewPasswordProvider);
                  return CustomButtonWithLoading(
                    isDisabled: disableBtn,
                    onPressed: () async => await _onChangePasswordPressed(provider),
                    title: LocaleKeys.continues.tr(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onChangePasswordPressed(WidgetRef ref) async {
    await ref
        .read(ForgetPasswordViewModel.changePasswordByResetPasswordProvider.notifier)
        .changePasswordByResetPassword(
          resetPasswordCode: widget.resetPasswordCode,
          password: passwordController.text,
        );

    final stateResetPassword = ref.watch(ForgetPasswordViewModel.changePasswordByResetPasswordProvider);

    if (stateResetPassword.hasValue) {
      navigatorKey.currentContext!.showToast(message: stateResetPassword.value?.data?.message ?? '');

      SharedPreferencesManager.remove(key: AppConstants.prefKeyUser);
      SharedPreferencesManager.remove(key: AppConstants.prefKeyAccessToken);
      LoginViewModel.navigateToLoginScreen();
    } else {
      navigatorKey.currentContext!.showToast(message: stateResetPassword.error.toString());
    }
  }
}
