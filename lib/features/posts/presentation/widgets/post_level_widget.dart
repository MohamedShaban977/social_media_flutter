import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/enums/post_level.dart';
import 'package:hauui_flutter/core/constants/enums/post_mode.dart';
import 'package:hauui_flutter/core/extensions/string_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';

class PostLevelWidget extends StatelessWidget {
  const PostLevelWidget.list({
    super.key,
    required this.level,
    required this.levelEnum,
  })  : postMode = PostMode.list,
        isSelected = null;

  const PostLevelWidget.create({
    super.key,
    required this.level,
    required this.levelEnum,
    this.isSelected = false,
  }) : postMode = PostMode.create;

  final PostMode postMode;
  final String level;
  final PostLevel levelEnum;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    final content = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              height: AppDimens.widgetDimen4pt,
              width: AppDimens.widgetDimen16pt,
              decoration: BoxDecoration(
                color: levelEnum.backgroundColor,
                borderRadius: BorderRadius.circular(
                  AppDimens.cornerRadius4pt,
                ),
              ),
            ),
            PositionedDirectional(
              start: 0,
              top: 0,
              child: Container(
                height: AppDimens.widgetDimen4pt,
                width: AppDimens.widgetDimen16pt / levelEnum.widthFillDivider,
                decoration: BoxDecoration(
                  color: levelEnum.color,
                  borderRadius: BorderRadius.circular(
                    AppDimens.cornerRadius4pt,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(width: AppDimens.widgetDimen8pt),
        Text(
          level.capitalize(),
          style: postMode == PostMode.list
              ? TextStyleManager.regular(
                  size: AppDimens.textSize10pt,
                  color: levelEnum.color,
                )
              : TextStyleManager.semiBold(
                  size: AppDimens.textSize10pt,
                  color: AppColors.veryDarkGrayishBlue,
                ),
        ),
      ],
    );
    final child = postMode == PostMode.list
        ? content
        : Container(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppDimens.spacingNormal,
              vertical: AppDimens.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightGrayishBlueOpacity42,
              border: Border.all(
                color: isSelected == true ? AppColors.veryDarkGrayishBlue : AppColors.transparent,
              ),
              borderRadius: BorderRadius.circular(
                AppDimens.cornerRadius8pt,
              ),
            ),
            child: content,
          );
    return child;
  }
}
