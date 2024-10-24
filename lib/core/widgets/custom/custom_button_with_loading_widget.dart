import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_progress_indicator.dart';

import 'custom_argon_button.dart';

class CustomButtonWithLoading extends StatelessWidget {
  const CustomButtonWithLoading({
    super.key,
    this.height = AppDimens.widgetDimen59pt,
    this.width,
    this.backgroundColor = AppColors.vividPink,
    this.textColor = AppColors.white,
    required this.onPressed,
    this.title,
    this.isDisabled = false,
    this.child,
    this.borderColor,
    this.verticalPadding = AppDimens.spacingNormal,
    this.horizontalPadding = AppDimens.spacingNormal,
    this.borderRadius = AppDimens.cornerRadius4pt,
    this.elevation = AppDimens.zero,
    this.loaderColor = AppColors.white,
  });

  final String? title;
  final double height;
  final double? width;
  final Color backgroundColor, textColor, loaderColor;
  final Color? borderColor;
  final Future<void> Function() onPressed;
  final bool isDisabled;
  final Widget? child;
  final double verticalPadding;
  final double horizontalPadding;
  final double borderRadius;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return CustomArgonButton(
      height: height,
      width: width ?? context.width,
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: borderColor ?? AppColors.transparent,
        width: AppDimens.borderWidth1pt,
      ),
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      roundLoadingShape: true,
      color: backgroundColor,
      disabledColor: AppColors.lightGrayishBlue2,
      disabledBtn: isDisabled,
      onPressed: (startLoading, stopLoading, ButtonState btnState) async {
        if (btnState == ButtonState.idle) {
          startLoading();
          await onPressed();
          stopLoading();
        } else {
          stopLoading();
        }
      },
      loader: SizedBox(
        height: height,
        width: height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spacingSmall),
            child: CircleAvatar(
              backgroundColor: backgroundColor,
              child: CustomProgressIndicator(
                color: loaderColor,
              ),
            ),
          ),
        ),
      ),
      elevation: elevation,
      textColor: textColor,
      child: child ??
          Text(
            title ?? '',
            style: TextStyleManager.semiBold(
              color: AppColors.white,
              size: AppDimens.textSize18pt,
            ),
          ),
    );
  }
}
