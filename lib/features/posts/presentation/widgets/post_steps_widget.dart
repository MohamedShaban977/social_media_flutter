import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/features/posts/data/models/post_models/post_step_model.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/post_step_item_widget.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/single_step_header_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class PostStepsWidget extends StatelessWidget {
  const PostStepsWidget({super.key, required this.steps});

  final List<PostStepModel> steps;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedIconColor: AppColors.vividPink,
      title: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Container(
            padding: const EdgeInsetsDirectional.all(AppDimens.spacingSmall),
            decoration: BoxDecoration(
              color: AppColors.lightGrayishBlue5,
              border: Border.all(width: AppDimens.borderWidth0Point5pt, color: AppColors.grayishBlue),
              shape: BoxShape.circle,
            ),
            child: Text(
              steps.length.toString(),
              style: TextStyleManager.medium(size: AppDimens.textSize14pt),
            ),
          ),
          const SizedBox(width: AppDimens.widgetDimen12pt),
          Text(
            LocaleKeys.steps.tr(),
            style: TextStyleManager.medium(size: AppDimens.textSize14pt),
          ),
        ],
      ),
      children: [
        const SizedBox(height: AppDimens.customSpacing4),
        const CustomDividerHorizontal(
          color: AppColors.lightGrayishBlue2,
          thickness: AppDimens.dividerThickness0Point5pt,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: AppDimens.spacingNormal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: steps
                .map(
                  (step) => (step.mediaAttributes ?? []).isNotEmpty
                      ? PostStepItemWidget(step: step)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  top: AppDimens.spacingSmall,
                                  start: AppDimens.spacingNormal,
                                  end: AppDimens.spacingNormal),
                              child: SingleStepHeaderWidget(stepNo: step.stepNo ?? 0, title: step.title ?? ""),
                            ),
                            const CustomDividerHorizontal(
                              color: AppColors.lightGrayishBlue2,
                              thickness: AppDimens.dividerThickness0Point5pt,
                            ),
                          ],
                        ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
