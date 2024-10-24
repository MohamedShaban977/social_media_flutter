import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/password_input_widget.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/privacy_policy_check_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_button_with_loading_widget.dart';
import 'package:hauui_flutter/features/authentication/register/presentation/screens/register_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class PasswordRegisterWidget extends StatefulWidget {
  final TextEditingController passwordController;
  final void Function() onRegisterPressed;

  const PasswordRegisterWidget({super.key, required this.passwordController, required this.onRegisterPressed});

  @override
  State<PasswordRegisterWidget> createState() => _PasswordRegisterWidgetState();
}

class _PasswordRegisterWidgetState extends State<PasswordRegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isVisiblePassword = ValueNotifier(true);

  @override
  void dispose() {
    _isVisiblePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Form(
            key: _formKey,
            onChanged: () => ref
                .read(RegisterViewModel.disableButtonByPasswordProvider.notifier)
                .update((state) => !_formKey.currentState!.validate()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
              child: Column(
                children: [
                  PasswordInputWidget(
                    passwordController: widget.passwordController,
                    label: LocaleKeys.password.tr(),
                    showValidation: true,
                    isVisiblePassword: _isVisiblePassword,
                  ),
                  const SizedBox(height: AppDimens.widgetDimen32pt),
                  const PrivacyPolicyCheckWidget(),
                  const SizedBox(height: AppDimens.widgetDimen24pt),
                  Consumer(
                    builder: (context, ref, child) {
                      final disableButton = ref.watch(RegisterViewModel.disableButtonByPasswordProvider);

                      return CustomButtonWithLoading(
                        isDisabled: disableButton,
                        onPressed: () async => await Future.sync(() => widget.onRegisterPressed()),
                        title: LocaleKeys.sendCode.tr(),
                      );
                    },
                  ),
                ],
              ),
            ));
      },
    );
  }
}
