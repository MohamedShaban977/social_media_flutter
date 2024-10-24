import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/models/hobby_model.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/text_form_field_with_label_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_progress_indicator.dart';

class SuggestAutoCompleteInputWidget extends StatelessWidget {
  const SuggestAutoCompleteInputWidget(
      {super.key,
      required this.controller,
      required this.suggestionsCallback,
      required this.suggestionsController,
      this.onSelected,
      required this.label,
      required this.hintText});

  final TextEditingController controller;
  final SuggestionsController<HobbyModel> suggestionsController;

  final FutureOr<List<HobbyModel>?> Function(String) suggestionsCallback;
  final void Function(HobbyModel)? onSelected;
  final String label;

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<HobbyModel>(
      controller: controller,
      suggestionsCallback: suggestionsCallback,
      builder: (context, controller, focusNode) {
        return TextFormFieldWithLabelWidget(
          label: label,
          hintText: hintText,
          controller: controller,
          focusNode: focusNode,
          scrollPadding: const EdgeInsets.only(bottom: AppDimens.widgetDimen171pt),
        );
      },
      suggestionsController: suggestionsController,
      itemBuilder: (context, hobby) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingSmall),
          child: Text(
            hobby.name ?? '',
            style: TextStyleManager.medium(
              color: AppColors.darkGrayishBlue,
              size: AppDimens.textSize14pt,
            ),
          ),
        );
      },
      decorationBuilder: (context, child) {
        if (suggestionsController.isOpen) {
          return Material(
            type: MaterialType.card,
            elevation: 1.0,
            color: AppColors.lightGrayishBlue3,
            borderRadius: BorderRadius.circular(AppDimens.cornerRadius4pt),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal, vertical: AppDimens.spacingSmall),
              child: child,
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
      offset: const Offset(AppDimens.zero, AppDimens.widgetDimen8pt),
      constraints: const BoxConstraints(maxHeight: AppDimens.widgetDimen155pt),
      loadingBuilder: (context) => const Center(child: CustomProgressIndicator()),
      hideOnEmpty: true,
      hideOnError: true,
      onSelected: onSelected,
    );
  }
}
