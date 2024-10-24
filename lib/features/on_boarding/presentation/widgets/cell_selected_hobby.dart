import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';

class CellSelectedHobby extends StatelessWidget {
  const CellSelectedHobby({
    super.key,
    required this.label,
    this.onDeleted,
  });

  final String label;
  final void Function()? onDeleted;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      labelStyle: TextStyleManager.semiBold(
        color: AppColors.primary,
        size: AppDimens.textSize12pt,
      ),
      backgroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.primary),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelPadding: const EdgeInsets.symmetric(vertical: AppDimens.customSpacing4),
      deleteIcon: CustomImage.svg(
        src: AppSvg.icCancel,
        color: AppColors.primary,
        height: AppDimens.widgetDimen8pt,
        width: AppDimens.widgetDimen8pt,
      ),
      onDeleted: onDeleted,
    );
  }
}
