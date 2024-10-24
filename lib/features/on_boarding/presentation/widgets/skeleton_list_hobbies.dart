import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/skeleton_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonListHobbies extends StatelessWidget {
  const SkeletonListHobbies({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Skeletonizer(
        enabled: true,
        child: ListView.builder(
          itemCount: 8,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spacingNormal,
              vertical: AppDimens.spacingSmall,
            ),
            child: Row(
              children: [
                SkeletonWidget(
                  width: context.width * 0.15,
                ),
                const Spacer(),
                const SkeletonWidget(
                  width: AppDimens.widgetDimen24pt,
                  height: AppDimens.widgetDimen24pt,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
