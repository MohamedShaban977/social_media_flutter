import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';

import '/core/constants/app_colors.dart';
import '/core/constants/app_dimens.dart';
import '/core/managers/theme/text_style_manager.dart';

class CustomEmptyState extends StatelessWidget {
  final String? image;
  final double? imageWidth;
  final double? imageHeight;
  final Color? imageColor;
  final BoxFit fit;
  final IconData? iconData;
  final double? iconSize;
  final Color? iconColor;
  final double drawableBottomPadding;
  final String? title;
  final double titleFontSize;
  final String? subTitle;
  final double? subTitleFontSize;
  final double subTitleTopPadding;
  final String? actionLabel;
  final void Function()? onTap;

  const CustomEmptyState({
    super.key,
    this.image,
    this.imageWidth,
    this.imageHeight,
    this.imageColor,
    this.fit = BoxFit.contain,
    this.iconData,
    this.iconSize,
    this.iconColor,
    this.drawableBottomPadding = AppDimens.spacing7XLarge,
    this.title,
    this.titleFontSize = AppDimens.textSize16pt,
    this.subTitle,
    this.subTitleFontSize = AppDimens.textSize14pt,
    this.subTitleTopPadding = AppDimens.spacingSmall,
    this.actionLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (image != null)
            Padding(
              padding: EdgeInsetsDirectional.only(
                bottom: drawableBottomPadding,
              ),
              child: CustomImage.svg(
                src: image!,
                width: imageWidth,
                height: imageHeight,
                color: imageColor,
                fit: fit,
              ),
            ),
          if (iconData != null)
            Padding(
              padding: EdgeInsetsDirectional.only(
                bottom: drawableBottomPadding,
              ),
              child: Icon(
                iconData,
                size: iconSize,
                color: iconColor,
              ),
            ),
          if (title != null)
            Text(
              title!,
              style: TextStyleManager.semiBold(
                size: titleFontSize,
                color: AppColors.veryDarkGrayishBlue,
              ),
              textAlign: TextAlign.center,
            ),
          if (subTitle != null)
            Padding(
              padding: EdgeInsetsDirectional.only(
                top: subTitleTopPadding,
              ),
              child: Text(
                subTitle!,
                style: TextStyleManager.regular(
                  size: subTitleFontSize,
                  color: AppColors.veryDarkGrayishBlue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          if (onTap != null)
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: AppDimens.spacingNormal,
                ),
                child: Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppDimens.spacingSmall,
                    vertical: AppDimens.spacingNormal,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: AppDimens.borderWidth1pt,
                      color: AppColors.white,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppDimens.cornerRadius4pt,
                    ),
                  ),
                  child: Text(
                    actionLabel!,
                    style: TextStyleManager.medium(
                      size: titleFontSize,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
