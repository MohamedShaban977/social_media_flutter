import 'package:flutter/material.dart';

import '/core/constants/app_colors.dart';
import '/core/constants/app_dimens.dart';
import '/core/constants/enums/image_type.dart';
import '/core/managers/theme/text_style_manager.dart';
import 'custom_image.dart';

class CustomDialog extends StatelessWidget {
  final String? icon;
  final ImageType iconType;
  final Color? iconColor;
  final String? title;
  final String? subTitle;
  final String? content;
  final String? negativeBtnName;
  final VoidCallback? negativeBtnAction;
  final Color negativeButtonBackgroundColor;
  final Color negativeButtonBorderColor;
  final Color negativeButtonForegroundColor;
  final String? positiveBtnName;
  final VoidCallback? positiveBtnAction;
  final Color positiveButtonBackgroundColor;

  const CustomDialog.normal({
    super.key,
    this.icon,
    this.iconType = ImageType.svg,
    this.iconColor,
    this.title,
    this.subTitle,
    this.content,
    this.negativeBtnName,
    this.negativeBtnAction,
    this.positiveBtnName,
    this.positiveBtnAction,
  })  : negativeButtonBackgroundColor = AppColors.primary,
        negativeButtonBorderColor = AppColors.transparent,
        negativeButtonForegroundColor = AppColors.white,
        positiveButtonBackgroundColor = AppColors.primary;

  const CustomDialog.constructive({
    super.key,
    this.icon,
    this.iconType = ImageType.svg,
    this.iconColor,
    this.title,
    this.subTitle,
    this.content,
    this.negativeBtnName,
    this.negativeBtnAction,
    this.positiveBtnName,
    this.positiveBtnAction,
  })  : negativeButtonBackgroundColor = AppColors.transparent,
        negativeButtonBorderColor = AppColors.transparent,
        negativeButtonForegroundColor = AppColors.primary,
        positiveButtonBackgroundColor = AppColors.primary;

  const CustomDialog.destructive({
    super.key,
    this.icon,
    this.iconType = ImageType.svg,
    this.iconColor,
    this.title,
    this.subTitle,
    this.content,
    this.negativeBtnName,
    this.negativeBtnAction,
    this.positiveBtnName,
    this.positiveBtnAction,
  })  : negativeButtonBackgroundColor = AppColors.transparent,
        negativeButtonBorderColor = AppColors.transparent,
        negativeButtonForegroundColor = AppColors.primary,
        positiveButtonBackgroundColor = AppColors.lightRed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.all(
        AppDimens.spacingNormal,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: AppDimens.spacingNormal,
          top: AppDimens.spacingLarge,
          end: AppDimens.spacingNormal,
          bottom: AppDimens.spacingXLarge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  bottom: AppDimens.spacingXLarge,
                ),
                child: Center(
                  child: iconType == ImageType.svg
                      ? CustomImage.svg(
                          src: icon!,
                          color: iconColor,
                        )
                      : CustomImage.asset(
                          src: icon!,
                          color: iconColor,
                        ),
                ),
              ),
            if (title != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  bottom: AppDimens.spacingSmall,
                ),
                child: Center(
                  child: Text(
                    title!,
                    style: TextStyleManager.bold(
                      size: AppDimens.textSize24pt,
                      color: AppColors.veryDarkDesaturatedBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (content != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  bottom: AppDimens.spacingNormal,
                ),
                child: Center(
                  child: Text(
                    content!,
                    style: TextStyleManager.medium(
                      size: AppDimens.textSize18pt,
                      color: AppColors.veryDarkGrayishBlue3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (positiveBtnName != null)
              ElevatedButton(
                onPressed: () {
                  if (positiveBtnAction != null) positiveBtnAction!();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: positiveButtonBackgroundColor,
                ),
                child: Text(
                  positiveBtnName!,
                ),
              ),
            if (negativeBtnName != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: AppDimens.spacingNormal,
                ),
                child: OutlinedButton(
                  onPressed: () {
                    if (negativeBtnAction != null) negativeBtnAction!();
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: negativeButtonForegroundColor,
                    backgroundColor: negativeButtonBackgroundColor,
                    side: BorderSide(
                      width: 1,
                      color: negativeButtonBorderColor,
                    ),
                  ),
                  child: Text(
                    negativeBtnName!,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
