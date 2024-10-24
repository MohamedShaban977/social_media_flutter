import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

class CustomDropdownFormFieldSearchablePaginated<T> extends StatelessWidget {
  const CustomDropdownFormFieldSearchablePaginated(
      {super.key,
      required this.paginatedRequest,
      this.hintText,
      this.onChanged,
      this.validator,
      this.dropDownMaxHeight = AppDimens.widgetDimen300pt,
      this.isEnabled = true});

  final Future<List<SearchableDropdownMenuItem<T>>?> Function(int, String?)? paginatedRequest;
  final String? hintText;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final double? dropDownMaxHeight;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: false,
        inputDecorationTheme: null,
      ),
      child: SearchableDropdownFormField<T>.paginated(
        hintText: Text(
          hintText ?? '',
          style: TextStyleManager.medium(
            color: isEnabled ? AppColors.darkGrayishBlue : AppColors.lightGrayishBlue,
            size: AppDimens.textSize14pt,
          ),
        ),
        margin: const EdgeInsets.all(AppDimens.zero),
        paginatedRequest: paginatedRequest,
        requestItemCount: ApiConstants.defaultPageSize,
        onChanged: onChanged,
        validator: validator,
        dropDownMaxHeight: dropDownMaxHeight,
        trailingIcon: Padding(
          padding: const EdgeInsets.only(top: AppDimens.customSpacing4),
          child: Icon(
            Icons.arrow_drop_down,
            color: isEnabled ? AppColors.veryDarkDesaturatedBlue : AppColors.darkGrayishBlue,
            size: AppDimens.widgetDimen24pt,
          ),
        ),
        isEnabled: isEnabled,
        dialogOffset: AppDimens.zero,
        backgroundDecoration: (child) {
          return Container(
            padding: const EdgeInsets.all(AppDimens.spacingNormal),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimens.cornerRadius4pt),
              border: Border.all(
                width: AppDimens.borderWidth1pt,
                color: AppColors.lightGrayishBlue,
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }
}
