import 'package:flutter/material.dart';

import '/core/constants/app_colors.dart';
import '/core/constants/app_dimens.dart';
import '/core/constants/enums/text_field_type.dart';
import '/core/extensions/context_extensions.dart';
import '/core/managers/theme/text_style_manager.dart';

class CustomDateTimeFiled extends StatelessWidget {
  final TextFieldType textFieldType;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime)? onDatePicked;
  final TimeOfDay? initialTime;
  final Function(TimeOfDay)? onTimePicked;
  final TextEditingController controller;
  final String label;
  final String? suffixIcon;
  final Color? suffixIconColor;
  final String? Function(String?)? validator;

  const CustomDateTimeFiled.date({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    required this.onDatePicked,
    required this.controller,
    required this.label,
    this.suffixIcon,
    this.suffixIconColor,
    this.validator,
  })  : textFieldType = TextFieldType.dateTextField,
        initialTime = null,
        onTimePicked = null;

  const CustomDateTimeFiled.time({
    super.key,
    this.initialTime,
    required this.onTimePicked,
    required this.controller,
    required this.label,
    this.suffixIcon,
    this.suffixIconColor,
    this.validator,
  })  : textFieldType = TextFieldType.timeTextField,
        initialDate = null,
        firstDate = null,
        lastDate = null,
        onDatePicked = null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onDatePicked != null
          ? context.presentDatePicker(
              onDatePicked: onDatePicked!,
              initialDate: initialDate,
              firstDate: firstDate,
              lastDate: lastDate,
            )
          : context.presentTimePicker(
              onTimePicked: onTimePicked!,
              initialTime: initialTime,
            ),
      child: TextFormField(
        controller: controller,
        enabled: false,
        style: TextStyleManager.medium(
          size: AppDimens.spacingNormal,
          color: AppColors.white,
        ),
        decoration: InputDecoration(
          label: Text(
            label,
          ),
          suffixIcon: suffixIcon == null
              ? null
              : Image.asset(
                  suffixIcon!,
                  color: suffixIconColor,
                ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              width: AppDimens.borderWidth1pt,
              color: AppColors.darkGrayishBlue2,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: AppDimens.borderWidth1pt,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error, // or any other color
          ),
        ),
        validator: validator,
      ),
    );
  }
}
