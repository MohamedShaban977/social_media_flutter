import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/verification_type.dart';
import 'package:hauui_flutter/core/constants/enums/verify_by.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/phone_number_with_country_code_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_button_with_loading_widget.dart';
import 'package:hauui_flutter/features/authentication/forget_password/data/requests_bodies/forget_password_request_body.dart';
import 'package:hauui_flutter/features/authentication/forget_password/presentation/screens/forget_password_view_model.dart';
import 'package:hauui_flutter/features/authentication/verification/data/models/verification_route_model.dart';
import 'package:hauui_flutter/features/authentication/verification/presentation/screens/verification_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class ForgetPasswordByPhoneNumberWidget extends ConsumerStatefulWidget {
  const ForgetPasswordByPhoneNumberWidget({super.key});

  @override
  ConsumerState<ForgetPasswordByPhoneNumberWidget> createState() => _ForgetPasswordByPhoneNumberWidgetState();
}

class _ForgetPasswordByPhoneNumberWidgetState extends ConsumerState<ForgetPasswordByPhoneNumberWidget> {
  final phoneNumberController = TextEditingController();

  final countryCodeController = TextEditingController();

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
                .read(ForgetPasswordViewModel.disableSubmitButtonByPhoneProvider.notifier)
                .update((state) => !_formState.currentState!.validate()),
            child: PhoneNumberWithCountryCodeWidget(
              phoneNumberController: phoneNumberController,
              countryCodeController: countryCodeController,
            ),
          ),
          const SizedBox(height: AppDimens.widgetDimen24pt),
          Consumer(
            builder: (context, provider, child) {
              final isDisableBtn = provider.watch(ForgetPasswordViewModel.disableSubmitButtonByPhoneProvider);

              return CustomButtonWithLoading(
                isDisabled: isDisableBtn,
                onPressed: () async => _onForgetPasswordByPhonePressed(provider),
                title: LocaleKeys.sendCode.tr(),
              );
            },
          ),
          const SizedBox(height: AppDimens.widgetDimen24pt),
        ],
      ),
    );
  }

  Future<void> _onForgetPasswordByPhonePressed(WidgetRef ref) async {
    await ref.read(ForgetPasswordViewModel.forgetPasswordProvider.notifier).forgetPassword(ForgetPasswordRequestBody(
          phoneNumber: phoneNumberController.text,
          countryCode: countryCodeController.text,
        ));

    final forgetPasswordState = ref.watch(ForgetPasswordViewModel.forgetPasswordProvider);

    if (forgetPasswordState.hasValue) {
      if (forgetPasswordState.value != null && forgetPasswordState.value!.success) {
        VerificationViewModel.navigateToVerificationScreen(
          VerificationRouteModel(
            title: LocaleKeys.forgetPassword.tr(),
            verifyBy: VerifyBy.sms,
            senderData: '${countryCodeController.text} ${phoneNumberController.text}',
            navigationFromWhere: VerificationType.forgetPassword,
            verificationCode: forgetPasswordState.value?.data?.verificationCode?.toString(),
          ),
        );
      } else {
        navigatorKey.currentContext!.showToast(message: forgetPasswordState.value!.message.toString());
      }
    }
    if (forgetPasswordState.hasError) {
      navigatorKey.currentContext!.showToast(message: forgetPasswordState.error.toString());
    }
  }
}
