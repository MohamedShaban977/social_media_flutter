import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';

import '/core/constants/app_colors.dart';

class CustomDividerVertical extends StatelessWidget {
  final double width;
  final double thickness;
  final double indent;
  final double endIndent;
  final Color color;

  const CustomDividerVertical({
    super.key,
    this.width = 0,
    this.thickness = AppDimens.dividerThickness1pt,
    this.indent = 0,
    this.endIndent = 0,
    this.color = AppColors.lightGrayishBlue2,
  });

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: width,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }
}
