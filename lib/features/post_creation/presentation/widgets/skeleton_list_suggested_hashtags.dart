import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/skeleton_widget.dart';
import 'package:hauui_flutter/features/post_creation/presentation/widgets/chip_solid_light_grayish_blue2_opacity40_corner14.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonListSuggestedHashtags extends StatelessWidget {
  const SkeletonListSuggestedHashtags({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return ChipSolidLightGrayishBlue2Opacity40Corner14.skeleton(
            skeletonWidget: SkeletonWidget(
              width: context.width * 0.15,
            ),
          );
        },
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsetsDirectional.only(
            end: AppDimens.spacingSmall,
          ),
        ),
        itemCount: 3,
      ),
    );
  }
}
