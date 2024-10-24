import 'package:flutter/cupertino.dart';

import '/core/constants/app_colors.dart';

class CustomCupertinoSwitch extends StatelessWidget {
  final Color activeColor;
  final Color trackColor;
  final bool value;
  final void Function(bool) onChanged;

  const CustomCupertinoSwitch({
    super.key,
    this.activeColor = AppColors.primary,
    this.trackColor = AppColors.darkGrayishBlue,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      activeColor: activeColor,
      trackColor: trackColor,
      value: value,
      onChanged: onChanged,
    );
  }
}
