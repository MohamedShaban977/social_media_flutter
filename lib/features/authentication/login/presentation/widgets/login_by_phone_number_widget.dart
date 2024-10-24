import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/firebase_manager.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/password_input_widget.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/phone_number_with_country_code_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_button_with_loading_widget.dart';
import 'package:hauui_flutter/features/authentication/login/data/requests_bodies/device_model.dart';
import 'package:hauui_flutter/features/authentication/login/data/requests_bodies/login_request_body.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/screens/login_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

import 'button_forget_password_widget.dart';

class LoginByPhoneNumberWidget extends ConsumerStatefulWidget {
  const LoginByPhoneNumberWidget({
    super.key,
  });

  @override
  ConsumerState<LoginByPhoneNumberWidget> createState() => _LoginByPhoneNumberWidgetState();
}

class _LoginByPhoneNumberWidgetState extends ConsumerState<LoginByPhoneNumberWidget> {
  final phoneNumberController = TextEditingController();
  final countryCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isVisiblePassword = ValueNotifier(true);

  @override
  void dispose() {
    phoneNumberController.dispose();
    countryCodeController.dispose();
    passwordController.dispose();
    _isVisiblePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () => ref
          .read(LoginViewModel.disableLoginButtonByPhoneProvider.notifier)
          .update((state) => !_formKey.currentState!.validate()),
      child: Column(
        children: [
          PhoneNumberWithCountryCodeWidget(
            phoneNumberController: phoneNumberController,
            countryCodeController: countryCodeController,
          ),

          const SizedBox(height: AppDimens.widgetDimen16pt),

          /// input password
          PasswordInputWidget(
            passwordController: passwordController,
            label: LocaleKeys.password.tr(),
            isVisiblePassword: _isVisiblePassword,
          ),

          const SizedBox(height: AppDimens.widgetDimen16pt),

          /// forget password
          const ButtonForgetPasswordWidget(),

          const SizedBox(height: AppDimens.widgetDimen24pt),

          /// login button
          Consumer(
            builder: (context, provider, child) {
              final isDisableBtn = provider.watch(LoginViewModel.disableLoginButtonByPhoneProvider);

              return CustomButtonWithLoading(
                isDisabled: isDisableBtn,
                onPressed: () async => _onLoginPressed(provider),
                title: LocaleKeys.login.tr(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onLoginPressed(WidgetRef ref) async {
    Fluttertoast.cancel();

    final fcmToken = await FirebaseManager.getFcmToken();
    await ref.read(LoginViewModel.loginProvider.notifier).login(
          LoginRequestBody(
            countryCode: countryCodeController.text,
            phoneNumber: phoneNumberController.text,
            password: passwordController.text,
            device: DeviceModel(token: fcmToken ?? ''),
          ),
        );
  }
}
