import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_check_box.dart';

class CellHobby extends StatelessWidget {
  const CellHobby({
    super.key,
    required this.title,
    this.isSelected = false,
    this.isParentHobbies = false,
    required this.onChanged,
  });

  final String title;
  final bool isSelected;
  final bool isParentHobbies;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!isSelected),
      borderRadius: BorderRadius.circular(AppDimens.spacingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (isParentHobbies) ...[
            Container(
              width: AppDimens.customSpacing4,
              height: AppDimens.customSpacing4,
              decoration: const ShapeDecoration(
                color: AppColors.veryDarkGrayishBlue,
                shape: OvalBorder(),
              ),
            ),
            const SizedBox(width: AppDimens.customSpacing4),
          ] else
            const SizedBox(width: AppDimens.widgetDimen8pt),
          Text(
            title,
            style: TextStyleManager.medium(
              color: isSelected
                  ? AppColors.vividCyan
                  : isParentHobbies
                      ? AppColors.veryDarkGrayishBlue
                      : AppColors.veryDarkGrayishBlue.withOpacity(0.5),
              size: AppDimens.textSize16pt,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: AppDimens.widgetDimen24pt,
            height: AppDimens.widgetDimen24pt,
            child: CustomCheckBox(value: isSelected, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}
