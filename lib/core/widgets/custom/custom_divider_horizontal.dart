import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';

import '/core/constants/app_colors.dart';

class CustomDividerHorizontal extends StatelessWidget {
  final double height;
  final double thickness;
  final double indent;
  final double endIndent;
  final Color color;

  const CustomDividerHorizontal({
    super.key,
    this.height = 0,
    this.thickness = AppDimens.dividerThickness1pt,
    this.indent = 0,
    this.endIndent = 0,
    this.color = AppColors.lightGrayishBlue2,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }
}
