import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/verification_type.dart';
import 'package:hauui_flutter/core/constants/enums/verify_by.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/extensions/string_extensions.dart';
import 'package:hauui_flutter/core/utils/validation_util.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/text_form_field_with_label_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_button_with_loading_widget.dart';
import 'package:hauui_flutter/features/authentication/forget_password/data/requests_bodies/forget_password_request_body.dart';
import 'package:hauui_flutter/features/authentication/forget_password/presentation/screens/forget_password_view_model.dart';
import 'package:hauui_flutter/features/authentication/verification/data/models/verification_route_model.dart';
import 'package:hauui_flutter/features/authentication/verification/presentation/screens/verification_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class ForgetPasswordByEmailWidget extends ConsumerStatefulWidget {
  const ForgetPasswordByEmailWidget({super.key});

  @override
  ConsumerState<ForgetPasswordByEmailWidget> createState() => _ForgetPasswordByEmailWidgetState();
}

class _ForgetPasswordByEmailWidgetState extends ConsumerState<ForgetPasswordByEmailWidget> {
  final emailController = TextEditingController();

  final _formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
      child: Column(
        children: [
          const SizedBox(height: AppDimens.widgetDimen32pt),
          Form(
            key: _formState,
            onChanged: () => ref
                .read(ForgetPasswordViewModel.disableSubmitButtonByEmailProvider.notifier)
                .update((state) => !_formState.currentState!.validate()),
            child: TextFormFieldWithLabelWidget(
              controller: emailController,
              label: LocaleKeys.email.tr(),
              hintText: LocaleKeys.hintEmail.tr(),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) => ValidationUtil.isValidEmail(value!)?.empty(),
            ),
          ),
          const SizedBox(height: AppDimens.widgetDimen24pt),
          Consumer(
            builder: (context, provider, child) {
              final isDisableBtn = provider.watch(ForgetPasswordViewModel.disableSubmitButtonByEmailProvider);

              return CustomButtonWithLoading(
                isDisabled: isDisableBtn,
                onPressed: () async => await _onForgetPasswordByEmailPressed(provider),
                title: LocaleKeys.sendCode.tr(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _onForgetPasswordByEmailPressed(WidgetRef ref) async {
    await ref.read(ForgetPasswordViewModel.forgetPasswordProvider.notifier).forgetPassword(ForgetPasswordRequestBody(
          email: emailController.text,
        ));

    final forgetPasswordState = ref.watch(ForgetPasswordViewModel.forgetPasswordProvider);

    if (forgetPasswordState.hasValue) {
      if (forgetPasswordState.value?.success ?? false) {
        VerificationViewModel.navigateToVerificationScreen(
          VerificationRouteModel(
            title: LocaleKeys.forgetPassword.tr(),
            verifyBy: VerifyBy.email,
            navigationFromWhere: VerificationType.forgetPassword,
            senderData: emailController.text,
          ),
        );
        navigatorKey.currentContext!.showToast(message: forgetPasswordState.value?.data?.message ?? '');
      } else {
        navigatorKey.currentContext!.showToast(message: forgetPasswordState.value!.message.toString());
      }
    }
    if (forgetPasswordState.hasError) {
      navigatorKey.currentContext!.showToast(message: forgetPasswordState.error.toString());
    }
  }
}
