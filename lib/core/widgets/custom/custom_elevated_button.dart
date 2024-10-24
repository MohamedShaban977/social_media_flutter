import 'package:flutter/material.dart';

import '/core/constants/app_colors.dart';
import '/core/constants/app_dimens.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final double width;
  final double height;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final ButtonStyle? style;
  final double horizontalPadding;
  final double verticalPadding;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Widget? leading;
  final Widget? trailer;

  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = AppDimens.widgetDimen100pt,
    this.height = 0,
    this.foregroundColor,
    this.backgroundColor,
    this.style,
    this.textStyle,
    this.horizontalPadding = AppDimens.spacingNormal,
    this.verticalPadding = AppDimens.spacingNormal,
    this.borderRadius = AppDimens.cornerRadius4pt,
    this.borderWidth = AppDimens.borderWidth1pt,
    this.borderColor = AppColors.transparent,
    this.leading,
    this.trailer,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
          side: BorderSide(
            width: borderWidth,
            color: borderColor,
          ),
        ),
      ).merge(style),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(
              width: AppDimens.widgetDimen16pt,
            )
          ],
          Text(
            label,
          ),
          if (trailer != null) ...[
            const SizedBox(
              width: AppDimens.widgetDimen8pt,
            ),
            trailer!
          ]
        ],
      ),
    );
  }
}
