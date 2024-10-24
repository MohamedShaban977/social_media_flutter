import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/skeleton_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonLevelsCard extends StatelessWidget {
  const SkeletonLevelsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          3,
          (index) => Skeletonizer(
                enabled: true,
                child: Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.cornerRadius8pt),
                      side: const BorderSide(
                        color: AppColors.lightGrayishBlue4,
                        width: AppDimens.borderWidth1pt,
                      )),
                  margin: const EdgeInsets.symmetric(vertical: AppDimens.spacingNormal),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.spacingNormal),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              )),
    );
  }
}
