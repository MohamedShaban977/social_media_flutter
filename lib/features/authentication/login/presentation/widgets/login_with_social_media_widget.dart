import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/privacy_policy_check_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';

class LoginWithSocialMediaWidget extends StatelessWidget {
  LoginWithSocialMediaWidget({
    super.key,
  });

  final _isDisabledButton = ValueNotifier<bool>(true);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: () => _isDisabledButton.value = !_formKey.currentState!.validate(),
      child: Column(
        children: [
          ValueListenableBuilder(
            builder: (context, isDisabled, child) {
              return Wrap(
                alignment: WrapAlignment.center,
                children: [
                  ///TODO: Login by Google
                  InkWell(
                    onTap: isDisabled ? null : () => navigatorKey.currentContext!.showToast(message: 'Login by Google'),
                    borderRadius: BorderRadius.circular(AppDimens.cornerRadius50pt),
                    splashColor: AppColors.primary.withOpacity(0.3),
                    child: Container(
                      decoration: const ShapeDecoration(
                        color: AppColors.lightGrayishBlue3,
                        shape: OvalBorder(),
                      ),
                      margin: const EdgeInsets.all(AppDimens.customSpacing4),
                      child: CustomImage.svg(
                        src: AppSvg.icLogoGoogle,
                        color: isDisabled ? AppColors.darkGrayishBlue3 : null,
                      ),
                    ),
                  ),

                  const SizedBox(width: AppDimens.widgetDimen24pt),

                  ///TODO: Login by Facebook
                  InkWell(
                    onTap:
                        isDisabled ? null : () => navigatorKey.currentContext!.showToast(message: 'Login by Facebook'),
                    borderRadius: BorderRadius.circular(AppDimens.cornerRadius50pt),
                    splashColor: AppColors.primary.withOpacity(0.3),
                    child: Container(
                      decoration: const ShapeDecoration(
                        color: AppColors.lightGrayishBlue3,
                        shape: OvalBorder(),
                      ),
                      margin: const EdgeInsets.all(AppDimens.customSpacing4),
                      child: CustomImage.svg(
                        src: AppSvg.icLogoFacebook,
                        color: isDisabled ? AppColors.darkGrayishBlue3 : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.widgetDimen24pt),

                  ///TODO: Login by Twitter
                  InkWell(
                    onTap:
                        isDisabled ? null : () => navigatorKey.currentContext!.showToast(message: 'Login by Twitter'),
                    borderRadius: BorderRadius.circular(AppDimens.cornerRadius50pt),
                    splashColor: AppColors.primary.withOpacity(0.3),
                    child: Container(
                      decoration: const ShapeDecoration(
                        color: AppColors.lightGrayishBlue3,
                        shape: OvalBorder(),
                      ),
                      margin: const EdgeInsets.all(AppDimens.customSpacing4),
                      child: CustomImage.svg(
                        src: AppSvg.icLogoTwitter,
                        color: isDisabled ? AppColors.darkGrayishBlue3 : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.widgetDimen24pt),

                  ///TODO: Login by Apple
                  Platform.isIOS
                      ? InkWell(
                          onTap: isDisabled
                              ? null
                              : () => navigatorKey.currentContext!.showToast(message: 'Login by Apple'),
                          borderRadius: BorderRadius.circular(AppDimens.cornerRadius50pt),
                          splashColor: AppColors.primary.withOpacity(0.3),
                          child: Container(
                            decoration: const ShapeDecoration(
                              color: AppColors.lightGrayishBlue3,
                              shape: OvalBorder(),
                            ),
                            margin: const EdgeInsets.all(AppDimens.customSpacing4),
                            child: CustomImage.svg(
                              src: AppSvg.icLogoApple,
                              color: isDisabled ? AppColors.darkGrayishBlue3 : null,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              );
            },
            valueListenable: _isDisabledButton,
          ),
          const Padding(
            padding: EdgeInsets.all(AppDimens.spacingNormal),
            child: PrivacyPolicyCheckWidget(),
          )
        ],
      ),
    );
  }
}
