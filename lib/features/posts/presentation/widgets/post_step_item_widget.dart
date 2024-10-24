import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/features/posts/data/models/post_models/post_model.dart';
import 'package:hauui_flutter/features/posts/data/models/post_models/post_step_model.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/post_display_media.dart';

import 'single_step_header_widget.dart';

class PostStepItemWidget extends StatelessWidget {
  const PostStepItemWidget({super.key, required this.step});

  final PostStepModel step;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          title: SingleStepHeaderWidget(stepNo: step.stepNo ?? 0, title: step.title ?? ""),
          collapsedIconColor: AppColors.vividCyan,
          iconColor: AppColors.vividCyan,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: AppDimens.spacingNormal),
              child: PostDisplayMedia(
                post: PostModel(mediaAttributes: step.mediaAttributes),
                height: AppDimens.widgetDimen190pt,
              ),
            ),
            const CustomDividerHorizontal(
              color: AppColors.lightGrayishBlue2,
              thickness: AppDimens.dividerThickness0Point5pt,
            ),
          ],
        ),
        const CustomDividerHorizontal(
          color: AppColors.lightGrayishBlue2,
          thickness: AppDimens.dividerThickness0Point5pt,
        ),
      ],
    );
  }
}
