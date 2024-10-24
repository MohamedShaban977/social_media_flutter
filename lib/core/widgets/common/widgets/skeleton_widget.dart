import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';

class SkeletonWidget extends StatelessWidget {
  const SkeletonWidget({
    super.key,
    this.radius = AppDimens.cornerRadius6pt,
    this.height = AppDimens.widgetDimen12pt,
    required this.width,
  });

  final double radius;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        width: width,
        color: AppColors.darkGray,
      ),
    );
  }
}
