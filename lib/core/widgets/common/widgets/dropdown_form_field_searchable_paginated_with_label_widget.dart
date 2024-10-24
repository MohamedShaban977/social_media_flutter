import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_dropdown_form_field_searchable_paginated.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class DropdownFormFieldSearchablePaginatedWithLabelWidget<T> extends StatelessWidget {
  const DropdownFormFieldSearchablePaginatedWithLabelWidget(
      {super.key,
      this.paginatedRequest,
      this.hintText,
      this.onChanged,
      this.validator,
      required this.label,
      this.dropDownMaxHeight,
      this.isEnabled = true});

  final String label;
  final Future<List<SearchableDropdownMenuItem<T>>?> Function(int, String?)? paginatedRequest;
  final String? hintText;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final double? dropDownMaxHeight;
  final bool isEnabled;

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
              color: isEnabled ? AppColors.black : AppColors.darkGrayishBlue,
              size: AppDimens.textSize12pt,
            ),
          ),
        ),
        const SizedBox(height: AppDimens.widgetDimen8pt),
        CustomDropdownFormFieldSearchablePaginated<T>(
          hintText: hintText,
          dropDownMaxHeight: dropDownMaxHeight,
          validator: validator,
          onChanged: onChanged,
          paginatedRequest: paginatedRequest,
          isEnabled: isEnabled,
        ),
      ],
    );
  }
}
