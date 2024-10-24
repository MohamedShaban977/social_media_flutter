import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/account_mode.dart';
import 'package:hauui_flutter/core/constants/enums/verification_type.dart';
import 'package:hauui_flutter/core/constants/enums/verify_by.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/extensions/bool_extensions.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/extensions/string_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/utils/validation_util.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_button_with_loading_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/authentication/account_view_model.dart';
import 'package:hauui_flutter/features/authentication/forget_password/data/requests_bodies/forget_password_request_body.dart';
import 'package:hauui_flutter/features/authentication/forget_password/presentation/screens/forget_password_view_model.dart';
import 'package:hauui_flutter/features/authentication/verification/data/models/verification_route_model.dart';
import 'package:hauui_flutter/features/authentication/verification/presentation/screens/verification_view_model.dart';
import 'package:hauui_flutter/features/authentication/verification/presentation/widgets/timer_button_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:pinput/pinput.dart';

class VerificationScreen extends StatefulWidget {
  final VerificationRouteModel verificationRouteModel;

  const VerificationScreen({
    super.key,
    required this.verificationRouteModel,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final pinController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.verificationRouteModel.verifyBy == VerifyBy.sms) {
        context.showToast(
          message: '${widget.verificationRouteModel.verificationCode}',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.verificationRouteModel.title),
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
            children: [
              SizedBox(height: context.height * 0.05),
              CustomImage.svg(
                src: AppSvg.icVerification,
                height: context.heightBody * 0.2,
              ),
              const SizedBox(height: AppDimens.widgetDimen24pt),
              Text(
                LocaleKeys.code.tr(),
                textAlign: TextAlign.center,
                style: TextStyleManager.bold(
                  color: AppColors.veryDarkDesaturatedBlue,
                  size: AppDimens.textSize24pt,
                ),
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),
              Text(
                widget.verificationRouteModel.navigationFromWhere == VerificationType.forgetPassword
                    ? LocaleKeys.sentCodeToRestYourPassword.tr(namedArgs: {
                        'type': widget.verificationRouteModel.verifyBy == VerifyBy.email
                            ? LocaleKeys.email.tr().toLowerCase()
                            : widget.verificationRouteModel.verifyBy == VerifyBy.sms
                                ? LocaleKeys.phoneNumber.tr().toLowerCase()
                                : '-'
                      })
                    : widget.verificationRouteModel.navigationFromWhere == VerificationType.register
                        ? LocaleKeys.sentCodeTo.tr(namedArgs: {
                            'type': widget.verificationRouteModel.verifyBy == VerifyBy.email
                                ? LocaleKeys.email.tr()
                                : widget.verificationRouteModel.verifyBy == VerifyBy.sms
                                    ? LocaleKeys.phoneNumber.tr().toLowerCase()
                                    : '-'
                          })
                        : '',
                textAlign: TextAlign.center,
                style: TextStyleManager.medium(
                  color: AppColors.veryDarkGrayishBlue3,
                  size: AppDimens.textSize18pt,
                ),
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),
              Text(
                widget.verificationRouteModel.senderData,
                textAlign: TextAlign.center,
                style: TextStyleManager.medium(
                  color: AppColors.black,
                  size: AppDimens.textSize20pt,
                ),
              ),
              const SizedBox(height: AppDimens.widgetDimen24pt),
              Consumer(
                builder: (context, ref, child) {
                  return Form(
                    key: _formKey,
                    onChanged: () => ref
                        .read(VerificationViewModel.disableVerificationButtonProvider.notifier)
                        .update((state) => !_formKey.currentState!.validate()),
                    child: Pinput(
                      length: 6,
                      controller: pinController,
                      autofocus: true,
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      onCompleted: (value) {},
                      onSubmitted: (value) {},
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) => ValidationUtil.isValidPinCode(value).empty(),
                      errorTextStyle: const TextStyle(height: 0.0),
                      defaultPinTheme: PinTheme(
                        width: AppDimens.widgetDimen45pt,
                        height: AppDimens.widgetDimen45pt,
                        textStyle: TextStyleManager.medium(
                          color: AppColors.veryDarkGrayishBlue,
                          size: AppDimens.textSize18pt,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: AppDimens.customSpacing4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: AppDimens.borderWidth1pt,
                            color: AppColors.darkGrayishBlue3,
                          ),
                          borderRadius: BorderRadius.circular(AppDimens.cornerRadius4pt),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),
              Consumer(
                builder: (context, ref, child) {
                  return TimerButtonWidget(
                    timer: AppConstants.resendCodeDelay,
                    onResendPressed: () async => await _onResendPressed(ref),
                  );
                },
              ),
              const SizedBox(height: AppDimens.widgetDimen32pt),
              Consumer(
                builder: (context, ref, child) {
                  final disableBtn = ref.watch(VerificationViewModel.disableVerificationButtonProvider);
                  return CustomButtonWithLoading(
                    isDisabled: disableBtn,
                    onPressed: () async => await _onDonePressed(ref),
                    title: LocaleKeys.done.tr(),
                  );
                },
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onResendPressed(WidgetRef ref) async {
    if (widget.verificationRouteModel.navigationFromWhere == VerificationType.forgetPassword) {
      await ref.read(ForgetPasswordViewModel.forgetPasswordProvider.notifier).forgetPassword(
            ForgetPasswordRequestBody(
              email: widget.verificationRouteModel.verifyBy == VerifyBy.email
                  ? widget.verificationRouteModel.senderData
                  : null,
              phoneNumber: widget.verificationRouteModel.verifyBy == VerifyBy.sms
                  ? widget.verificationRouteModel.senderData.split(' ').last
                  : null,
              countryCode: widget.verificationRouteModel.verifyBy == VerifyBy.sms
                  ? widget.verificationRouteModel.senderData.split(' ').first
                  : null,
            ),
          );

      final forgetPasswordState = ref.read(
        ForgetPasswordViewModel.forgetPasswordProvider,
      );
      if (mounted && forgetPasswordState.hasValue) {
        if (forgetPasswordState.value != null && forgetPasswordState.value!.success) {
          if (widget.verificationRouteModel.verifyBy == VerifyBy.sms) {
            context.showToast(
              message: '${forgetPasswordState.value?.data?.verificationCode}',
            );
          } else {
            context.showToast(
              message: '${forgetPasswordState.value?.data?.message}',
            );
          }
        } else {
          context.showToast(
            message: forgetPasswordState.value!.message.toString(),
          );
        }
      }
      if (mounted && forgetPasswordState.hasError) {
        context.showToast(
          message: forgetPasswordState.error.toString(),
        );
      }
    } else {
      await VerificationViewModel().resendOtp(
        userId: widget.verificationRouteModel.userId!,
        countryCode: widget.verificationRouteModel.verifyBy == VerifyBy.sms
            ? widget.verificationRouteModel.senderData.split(' ').first
            : null,
        phoneNumber: widget.verificationRouteModel.verifyBy == VerifyBy.sms
            ? widget.verificationRouteModel.senderData.split(' ').last
            : null,
        email:
            widget.verificationRouteModel.verifyBy == VerifyBy.email ? widget.verificationRouteModel.senderData : null,
        onSuccess: (message) => context.showToast(
          message: message,
        ),
        onFail: (errorMessage) => context.showToast(
          message: errorMessage,
        ),
      );
    }
  }

  Future<void> _onDonePressed(WidgetRef ref) async {
    if (widget.verificationRouteModel.navigationFromWhere == VerificationType.forgetPassword) {
      await ForgetPasswordViewModel().verifyForgetPasswordOTP(
        resetPasswordCode: pinController.text,
        onSuccess: () {
          ref.read(AccountViewModel.accountModeProvider.notifier).update(
                (state) => state = AccountMode.unauthorized,
              );

          ForgetPasswordViewModel.navigateToSetNewPasswordScreen(
            resetPasswordCode: pinController.text,
          );
        },
        onFail: (errorMessage) => context.showToast(
          message: errorMessage,
        ),
      );
    } else if (widget.verificationRouteModel.navigationFromWhere == VerificationType.register) {
      await ref.read(VerificationViewModel.verifyRegisterProvider.notifier).verifyRegister(
            verificationCode: pinController.text.orEmpty(),
            userId: widget.verificationRouteModel.userId!,
          );

      final verifyRegisterState = ref.watch(VerificationViewModel.verifyRegisterProvider);

      if (verifyRegisterState.hasValue && verifyRegisterState.value != null) {
        if (verifyRegisterState.value!.data != null && verifyRegisterState.value!.data!.verified.orFalse()) {
          Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, RoutesNames.levelsRoute, (_) => false);
        }
      }
      if (mounted && verifyRegisterState.hasError) {
        context.showToast(
          message: verifyRegisterState.error.toString(),
        );
      }
    }
  }
}
