import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';

class CellStatisticTopUser extends StatelessWidget {
  const CellStatisticTopUser({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyleManager.semiBold(
            color: AppColors.grayishBlue,
            size: AppDimens.textSize12pt,
          ),
        ),
        Text(
          value,
          style: TextStyleManager.bold(
            color: AppColors.veryDarkGrayishBlue,
            size: AppDimens.textSize14pt,
          ),
        ),
      ],
    );
  }
}
