import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_dropdown_form_field2.dart';

class DropdownButtonFormField2WithLabelWidget<T> extends StatelessWidget {
  const DropdownButtonFormField2WithLabelWidget({
    super.key,
    required this.label,
    this.hintText,
    this.disabledHint,
    this.items,
    this.validator,
    this.onChanged,
    this.maxHeightDropdown = AppDimens.widgetDimen300pt,
    this.disabled = false,
    this.value,
  });

  final String label;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppDimens.customSpacing4),
          child: Text(
            label,
            style: TextStyleManager.regular(
              color: AppColors.black,
              size: AppDimens.textSize12pt,
            ),
          ),
        ),
        const SizedBox(height: AppDimens.widgetDimen8pt),
        CustomDropdownFormField2<T>(
          hintText: hintText,
          disabledHint: disabledHint,
          items: items,
          validator: validator,
          onChanged: onChanged,
          maxHeightDropdown: maxHeightDropdown,
          disabled: disabled,
          value: value,
        ),
      ],
    );
  }
}
