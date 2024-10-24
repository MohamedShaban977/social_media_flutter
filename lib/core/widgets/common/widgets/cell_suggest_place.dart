import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';

class CellSuggestPlace extends StatelessWidget {
  const CellSuggestPlace({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.spacingNormal),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CustomImage.svg(
            src: AppSvg.icLocation,
            color: AppColors.vividCyan,
            width: AppDimens.widgetDimen16pt,
          ),
          const SizedBox(width: AppDimens.widgetDimen12pt),
          Expanded(
            child: Text(
              title,
              style: TextStyleManager.medium(
                color: AppColors.darkGrayishBlue,
                size: AppDimens.textSize14pt,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
