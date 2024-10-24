import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';

import '/core/constants/app_dimens.dart';
import '/core/managers/theme/text_style_manager.dart';

class CustomToast extends StatelessWidget {
  final String message;

  const CustomToast({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingNormal,
        vertical: AppDimens.spacingSmall,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppDimens.cornerRadius16pt,
        ),
        color: AppColors.veryDarkGrayishBlue,
      ),
      child: Text(
        message,
        style: TextStyleManager.regular(
          size: AppDimens.textSize14pt,
          color: AppColors.white,
        ),
      ),
    );
  }
}
