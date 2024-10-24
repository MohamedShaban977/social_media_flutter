import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/skeleton_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonJoiners extends StatelessWidget {
  const SkeletonJoiners({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        children: List.generate(
          6,
          (index) => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal, vertical: AppDimens.customSpacing4),
            child: Row(
              children: [
                const SkeletonWidget(
                  height: AppDimens.widgetDimen45pt,
                  width: AppDimens.widgetDimen45pt,
                  radius: AppDimens.cornerRadius50pt,
                ),
                const SizedBox(width: AppDimens.widgetDimen16pt),
                SkeletonWidget(
                  width: context.width * 0.2,
                ),
                const Spacer(),

                /// follow or unfollow button
                const SkeletonWidget(
                  width: AppDimens.widgetDimen80pt,
                  height: AppDimens.widgetDimen32pt,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
