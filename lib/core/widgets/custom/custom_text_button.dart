import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  final Color? foregroundColor;
  final TextStyle? textStyle;
  final ButtonStyle? style;

  const CustomTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.foregroundColor,
    this.style,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
        textStyle: textStyle,
      ).merge(style),
      child: Text(
        label,
      ),
    );
  }
}
