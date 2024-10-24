import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';

class CustomDropdownFormField2<T> extends StatelessWidget {
  const CustomDropdownFormField2({
    super.key,
    this.hintText,
    this.disabledHint,
    this.items,
    this.validator,
    this.onChanged,
    this.maxHeightDropdown = AppDimens.widgetDimen300pt,
    this.disabled = false,
    this.value,
  });

  final String? hintText;
  final String? disabledHint;
  final List<DropdownMenuItem<T>>? items;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final double? maxHeightDropdown;
  final bool disabled;
  final T? value;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      hint: Text(
        hintText ?? '',
        style: TextStyleManager.medium(
          color: AppColors.darkGrayishBlue,
          size: AppDimens.textSize14pt,
        ),
      ),
      disabledHint: Text(
        disabledHint ?? '',
        style: TextStyleManager.medium(
          color: AppColors.darkGrayishBlue,
          size: AppDimens.textSize14pt,
        ),
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: const InputDecoration(
          counterStyle: TextStyle(
            color: AppColors.veryDarkGrayishBlue,
          ),
          suffixIconConstraints: BoxConstraints(maxHeight: AppDimens.widgetDimen16pt),
          contentPadding: EdgeInsetsDirectional.fromSTEB(
              AppDimens.zero, AppDimens.spacingLarge, AppDimens.customSpacing12, AppDimens.customSpacing12)
          // contentPadding: Theme.of(context).inputDecorationTheme.contentPadding,
          ),
      items: items,
      validator: validator,
      onChanged: disabled ? null : onChanged,
      value: value,
      iconStyleData: const IconStyleData(
        openMenuIcon: Padding(
          padding: EdgeInsets.only(top: AppDimens.customSpacing4),
          child: Icon(
            Icons.arrow_drop_up,
            color: AppColors.veryDarkDesaturatedBlue,
          ),
        ),
        icon: Padding(
          padding: EdgeInsets.only(top: AppDimens.customSpacing4),
          child: Icon(
            Icons.arrow_drop_down,
            color: AppColors.veryDarkDesaturatedBlue,
          ),
        ),
        iconSize: AppDimens.widgetDimen24pt,
      ),
      isExpanded: true,
      dropdownStyleData: DropdownStyleData(
        elevation: 1,
        maxHeight: maxHeightDropdown,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius8pt),
          color: AppColors.lightGrayishBlue3,
        ),
      ),
    );
  }
}
