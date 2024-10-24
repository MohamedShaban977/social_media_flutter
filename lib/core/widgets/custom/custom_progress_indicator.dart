import 'package:flutter/material.dart';

import '/core/constants/app_colors.dart';
import '/core/constants/app_dimens.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color? color;

  const CustomProgressIndicator({super.key, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: AppDimens.strokeWidth3pt,
      ),
    );
  }
}
