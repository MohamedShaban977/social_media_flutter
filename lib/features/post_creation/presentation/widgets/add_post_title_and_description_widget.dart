import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_text_field.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class AddPostTitleAndDescriptionWidget extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const AddPostTitleAndDescriptionWidget({
    super.key,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          controller: titleController,
          hintText: LocaleKeys.addInterestingTitle.tr(),
          hintStyle: TextStyleManager.regular(
            size: AppDimens.textSize14pt,
            color: AppColors.grayishBlue,
          ),
          style: TextStyleManager.semiBold(
            size: AppDimens.textSize14pt,
            color: AppColors.veryDarkGrayishBlue,
          ),
          maxLength: AppConstants.postTitleMaxLength,
          contentPadding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppDimens.spacingSmall,
            vertical: AppDimens.customSpacing12,
          ),
          onTap: () => ScaffoldMessenger.of(context).clearSnackBars(),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            top: AppDimens.spacingNormal,
          ),
          child: CustomTextField(
            controller: descriptionController,
            hintText: LocaleKeys.writeYourPostHere.tr(),
            hintStyle: TextStyleManager.regular(
              size: AppDimens.textSize14pt,
              color: AppColors.grayishBlue,
            ),
            style: TextStyleManager.regular(
              size: AppDimens.textSize14pt,
              color: AppColors.veryDarkGrayishBlue,
            ),
            maxLength: AppConstants.postDescriptionMaxLength,
            textInputAction: TextInputAction.done,
            shouldHideBorder: true,
            contentPadding: EdgeInsetsDirectional.zero,
            onTap: () => ScaffoldMessenger.of(context).clearSnackBars(),
          ),
        ),
      ],
    );
  }
}
