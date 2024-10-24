import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';

class ChipSolidLightGrayishBlue2Opacity40Corner14 extends StatelessWidget {
  final String? title;
  final Widget? skeletonWidget;

  const ChipSolidLightGrayishBlue2Opacity40Corner14({
    super.key,
    required this.title,
  }) : skeletonWidget = null;

  const ChipSolidLightGrayishBlue2Opacity40Corner14.skeleton({
    super.key,
    required this.skeletonWidget,
  }) : title = null;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
      ),
      child: Chip(
        label: skeletonWidget ??
            Text(
              title!,
            ),
        labelStyle: TextStyleManager.regular(
          size: AppDimens.textSize14pt,
          color: AppColors.darkGrayishBlue,
        ),
        labelPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppDimens.spacingNormal,
        ),
        padding: EdgeInsetsDirectional.zero,
        backgroundColor: AppColors.lightGrayishBlue2.withOpacity(
          0.4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppDimens.cornerRadius14pt,
          ),
        ),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
