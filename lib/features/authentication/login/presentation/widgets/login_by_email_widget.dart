import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/string_extensions.dart';
import 'package:hauui_flutter/core/managers/firebase_manager.dart';
import 'package:hauui_flutter/core/utils/validation_util.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/password_input_widget.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/text_form_field_with_label_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_button_with_loading_widget.dart';
import 'package:hauui_flutter/features/authentication/login/data/requests_bodies/device_model.dart';
import 'package:hauui_flutter/features/authentication/login/data/requests_bodies/login_request_body.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/screens/login_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

import 'button_forget_password_widget.dart';

class LoginByEmailWidget extends ConsumerStatefulWidget {
  const LoginByEmailWidget({super.key});

  @override
  ConsumerState<LoginByEmailWidget> createState() => _LoginByEmailWidgetState();
}

class _LoginByEmailWidgetState extends ConsumerState<LoginByEmailWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isVisiblePassword = ValueNotifier(true);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _isVisiblePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () => ref
          .read(LoginViewModel.disableLoginButtonByEmailProvider.notifier)
          .update((state) => !_formKey.currentState!.validate()),
      child: Column(
        children: [
          TextFormFieldWithLabelWidget(
            controller: emailController,
            label: LocaleKeys.email.tr(),
            hintText: LocaleKeys.hintEmail.tr(),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) => ValidationUtil.isValidEmail(value!)?.empty(),
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
              final isDisableBtn = provider.watch(LoginViewModel.disableLoginButtonByEmailProvider);

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
            email: emailController.text,
            password: passwordController.text,
            device: DeviceModel(token: fcmToken ?? ''),
          ),
        );
  }
}
