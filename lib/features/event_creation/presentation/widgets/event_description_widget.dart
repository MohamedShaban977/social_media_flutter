import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/utils/validation_util.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_text_field.dart';
import 'package:hauui_flutter/features/post_creation/presentation/screens/post_creation_view_model.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/input_hashtags_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class EventDescriptionWidget extends StatelessWidget {
  const EventDescriptionWidget({super.key, this.controller});

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppDimens.customSpacing4),
          child: Text(
            LocaleKeys.description.tr(),
            style: TextStyleManager.regular(
              color: AppColors.black,
              size: AppDimens.textSize12pt,
            ),
          ),
        ),
        const SizedBox(height: AppDimens.widgetDimen8pt),
        FormField(
          enabled: true,
          validator: (value) => ValidationUtil.isValidInputField(controller?.text),
          builder: (field) => InputDecorator(
            isEmpty: true,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: AppDimens.borderWidth1pt,
                    color: field.hasError ? AppColors.red : AppColors.lightGrayishBlue,
                  ),
                ),
                errorText: field.errorText),
            child: Consumer(builder: (context, ref, child) {
              final hashtags = ref.watch(PostCreationViewModel.inputHashtagsProvider);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: controller,
                    hintText: LocaleKeys.writeEventDescription.tr(),
                    hintStyle: TextStyleManager.regular(
                      size: AppDimens.textSize14pt,
                      color: AppColors.grayishBlue,
                    ),
                    style: TextStyleManager.regular(
                      size: AppDimens.textSize14pt,
                    ).copyWith(height: 1.8),
                    maxLines: 5,
                    minLines: 1,
                    textInputAction: TextInputAction.done,
                    shouldHideBorder: true,
                    contentPadding: EdgeInsetsDirectional.zero,
                  ),
                  if (hashtags.isNotEmpty) ...[
                    const SizedBox(height: AppDimens.widgetDimen8pt),
                    const InputHashtagsWidget()
                  ],
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
