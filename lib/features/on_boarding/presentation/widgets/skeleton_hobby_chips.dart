import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/skeleton_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonHobbyChips extends StatelessWidget {
  const SkeletonHobbyChips({super.key});

  final dummyTitle = "title here";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
      child: Wrap(
          children: List.generate(
        2,
        (index) => Skeletonizer(
          enabled: true,
          child: Card(
            elevation: 0.5,
            // surfaceTintColor: AppColors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.cornerRadius8pt),
                side: const BorderSide(
                  color: AppColors.lightGrayishBlue4,
                  width: AppDimens.borderWidth1pt,
                )),
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.spacingSmall),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SkeletonWidget(
                    width: context.width * 0.15,
                  ),
                  const SizedBox(width: AppDimens.widgetDimen16pt),
                  const Icon(Icons.clear, size: AppDimens.widgetDimen16pt),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
