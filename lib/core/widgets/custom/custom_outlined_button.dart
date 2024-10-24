import 'package:flutter/material.dart';

import '/core/constants/app_colors.dart';
import '/core/constants/app_dimens.dart';

class CustomOutlinedButton extends StatelessWidget {
  final Widget? child;
  final String? label;
  final void Function()? onPressed;
  final double width;
  final double height;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Widget? leading;
  final Widget? trailer;

  const CustomOutlinedButton({
    super.key,
    this.child,
    this.label,
    required this.onPressed,
    this.width = AppDimens.widgetDimen100pt,
    this.height = 0,
    this.foregroundColor,
    this.backgroundColor,
    this.textStyle,
    this.horizontalPadding = AppDimens.spacingNormal,
    this.verticalPadding = AppDimens.spacingNormal,
    this.borderRadius = AppDimens.cornerRadius4pt,
    this.borderWidth = AppDimens.borderWidth1pt,
    this.borderColor = AppColors.veryDarkGrayishBlue,
    this.leading,
    this.trailer,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(
          width,
          height,
        ),
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        textStyle: textStyle,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        side: BorderSide(
          width: borderWidth,
          color: borderColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
        ),
      ),
      child: child ?? Text(label!),
    );
  }
}
