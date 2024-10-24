import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';

class SingleStepHeaderWidget extends StatelessWidget {
  const SingleStepHeaderWidget({super.key, required this.stepNo, required this.title});

  final int stepNo;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: AppDimens.spacingNormal,
        end: AppDimens.spacingSmall,
        bottom: AppDimens.spacingSmall,
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            padding: const EdgeInsetsDirectional.all(AppDimens.spacingSmall),
            decoration: const BoxDecoration(color: AppColors.vividCyan, shape: BoxShape.circle),
            child: Text(
              stepNo.toString(),
              style: TextStyleManager.medium(size: AppDimens.textSize14pt, color: AppColors.white),
            ),
          ),
          const SizedBox(width: AppDimens.widgetDimen12pt),
          Text(
            title,
            style: TextStyleManager.medium(size: AppDimens.textSize14pt, color: AppColors.grayishBlue2),
          ),
        ],
      ),
    );
  }
}
