import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';

class InvalidInputWidget extends StatelessWidget {
  final String errorMessage;

  const InvalidInputWidget({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: AppDimens.customSpacing12,
      ),
      child: Row(
        children: [
          const CustomImage.svg(
            src: AppSvg.icExclamationMarkTransparentRoundedRed,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: AppDimens.spacingSmall,
            ),
            child: Text(
              errorMessage,
              style: TextStyleManager.regular(
                size: AppDimens.textSize12pt,
                color: AppColors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}
