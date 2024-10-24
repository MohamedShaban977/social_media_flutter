import 'package:flutter/material.dart';

import '/core/constants/app_colors.dart';
import '/core/constants/app_dimens.dart';
import '/core/managers/theme/text_style_manager.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  final String label;
  final bool shouldLabelFollowRadioButtonColor;
  final T value;
  final T groupValue;
  final void Function(T?) onChanged;
  final ListTileControlAffinity listTileControlAffinity;

  const CustomRadioListTile({
    super.key,
    required this.label,
    this.shouldLabelFollowRadioButtonColor = false,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.listTileControlAffinity = ListTileControlAffinity.leading,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      contentPadding: EdgeInsetsDirectional.zero,
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
        vertical: VisualDensity.minimumDensity,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      controlAffinity: listTileControlAffinity,
      title: shouldLabelFollowRadioButtonColor
          ? Text(
              label,
              style: TextStyleManager.bold(
                size: AppDimens.textSize16pt,
                color: AppColors.vividPink,
              ),
            )
          : Text(
              label,
              style: TextStyleManager.regular(
                size: AppDimens.textSize14pt,
                color: AppColors.veryDarkGrayishBlue2,
              ),
            ),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
