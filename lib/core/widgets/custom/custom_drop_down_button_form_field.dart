import 'package:flutter/material.dart';

import '/core/constants/app_colors.dart';
import '/core/constants/app_dimens.dart';
import '/core/managers/theme/text_style_manager.dart';

class CustomDropdownButtonFormField<T> extends StatelessWidget {
  final String? hint;
  final T initialValue;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final TextStyle? hintStyle;

  final Color dropdownColor;

  const CustomDropdownButtonFormField({
    super.key,
    this.hint,
    required this.initialValue,
    required this.items,
    this.onChanged,
    this.validator,
    this.hintStyle,
    this.dropdownColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      hint: hint != null
          ? Text(
              hint!,
              style: TextStyleManager.medium(
                size: AppDimens.textSize14pt,
                color: AppColors.darkGrayishBlue,
              ).merge(
                hintStyle,
              ),
            )
          : null,
      dropdownColor: dropdownColor,
      iconEnabledColor: AppColors.veryDarkDesaturatedBlue,
      value: initialValue,
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
