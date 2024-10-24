import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_text_button.dart';

class SettingWidget extends StatelessWidget {
  const SettingWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.textStyle,
  });

  final String label;
  final void Function()? onPressed;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return CustomTextButton(
      label: label,
      style: TextButton.styleFrom(
        textStyle: textStyle ??
            TextStyleManager.medium(
              size: AppDimens.textSize14pt,
            ),
        fixedSize: Size.fromWidth(context.width),
        alignment: AlignmentDirectional.centerStart,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius4pt),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
