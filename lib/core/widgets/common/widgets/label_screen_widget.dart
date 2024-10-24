import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';

class LabelScreenWidget extends StatelessWidget {
  const LabelScreenWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.isAxisVirtual = false,
    this.sizeIcon,
    this.sizeTitle,
    this.sizeSubtitle,
    this.showLogo = true,
  });

  final String title;
  final String? subtitle;
  final double? sizeIcon;
  final double? sizeTitle;
  final double? sizeSubtitle;
  final bool isAxisVirtual;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isAxisVirtual) ...[
                Padding(
                  padding: const EdgeInsets.only(top: AppDimens.spacingSmall),
                  child: CustomImage.svg(
                    src: AppSvg.icLogoHauui,
                    width: sizeIcon ?? AppDimens.widgetDimen32pt,
                    height: sizeIcon ?? AppDimens.widgetDimen32pt,
                  ),
                ),
                const SizedBox(height: AppDimens.widgetDimen24pt),
              ],
              Text(
                title, //
                style: TextStyleManager.bold(
                  color: AppColors.veryDarkGrayishBlue,
                  size: sizeTitle ?? AppDimens.textSize20pt,
                ),
              ),
              SizedBox(height: isAxisVirtual ? AppDimens.widgetDimen8pt : AppDimens.customSpacing4),
              if (subtitle != null && subtitle != '')
                Text(
                  subtitle ?? '',
                  style: TextStyleManager.regular(
                    size: sizeSubtitle ?? AppDimens.textSize14pt,
                    color: AppColors.darkGrayishBlue2,
                  ),
                ),
            ],
          ),
        ),
        if (!isAxisVirtual && showLogo)
          Padding(
            padding: const EdgeInsets.only(top: AppDimens.spacingSmall),
            child: CustomImage.svg(
              src: AppSvg.icLogoHauui,
              width: AppDimens.widgetDimen32pt,
              height: AppDimens.widgetDimen32pt,
            ),
          ),
      ],
    );
  }
}
