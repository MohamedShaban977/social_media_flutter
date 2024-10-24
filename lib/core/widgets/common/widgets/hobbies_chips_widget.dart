import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';

class HobbiesChipsWidget extends StatelessWidget {
  const HobbiesChipsWidget({super.key, required this.hobbies});

  final List<String> hobbies;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimens.spacingSmall,
      children: List.generate(
        hobbies.length,
        (index) => Chip(
          label: Text(
            hobbies[index],
            style: TextStyleManager.medium(
              color: AppColors.darkGrayishBlue,
              size: AppDimens.textSize12pt,
            ),
          ),
          backgroundColor: AppColors.lightGrayishBlue2,
          elevation: AppDimens.zero,
          padding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spacingSmall,
            vertical: AppDimens.customSpacing4,
          ),
          visualDensity: VisualDensity.compact,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.cornerRadius10pt),
          ),
        ),
      ),
    );
  }
}
