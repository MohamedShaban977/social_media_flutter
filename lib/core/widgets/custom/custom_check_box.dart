import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final Color? checkColor;
  final Color? activeColor;
  final bool value;
  final void Function(bool?) onChanged;

  const CustomCheckBox({
    super.key,
    this.checkColor,
    this.activeColor,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: checkColor,
      activeColor: activeColor,
      value: value,
      onChanged: onChanged,
    );
  }
}
