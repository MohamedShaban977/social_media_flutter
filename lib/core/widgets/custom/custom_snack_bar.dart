import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/enums/snackbar_message_type.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_vertical.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';

import '/core/constants/app_dimens.dart';

class CustomSnackBar extends StatelessWidget {
  final SnackBarMessageType messageType;
  final String? icon;
  final String text;
  final Color? color;

  const CustomSnackBar({
    super.key,
    required this.messageType,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.spacing5XLarge,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (messageType != SnackBarMessageType.none)
            CustomImage.svg(
              src: icon,
            ),
          if (messageType != SnackBarMessageType.none)
            const Padding(
              padding: EdgeInsetsDirectional.only(
                start: AppDimens.customSpacing12,
              ),
              child: CustomDividerVertical(
                color: AppColors.white,
              ),
            ),
          Expanded(
            child: Padding(
              padding: messageType == SnackBarMessageType.none
                  ? EdgeInsets.zero
                  : const EdgeInsetsDirectional.only(
                      start: AppDimens.spacingSmall,
                    ),
              child: Text(
                text,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                style: TextStyleManager.regular(
                  size: AppDimens.textSize14pt,
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
