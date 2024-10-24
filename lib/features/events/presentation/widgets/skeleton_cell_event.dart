import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/skeleton_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_vertical.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonCellEvent extends StatelessWidget {
  const SkeletonCellEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: AppColors.lightGrayishBlue2,
        margin: const EdgeInsets.only(
          bottom: AppDimens.spacingXLarge,
          left: AppDimens.spacingNormal,
          right: AppDimens.spacingNormal,
        ),
        elevation: AppDimens.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.cornerRadius12pt),
            side: const BorderSide(
              width: AppDimens.borderWidth0Point5pt,
              color: AppColors.lightGrayishBlue2,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: AppDimens.widgetDimen200pt,
              width: double.infinity,
              color: AppColors.lightGrayishBlue,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimens.widgetDimen8pt),
                  Row(
                    children: [
                      SkeletonWidget(
                        width: context.width * 0.2,
                      ),
                      const SizedBox(width: AppDimens.widgetDimen8pt),
                      SkeletonWidget(
                        width: context.width * 0.2,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.widgetDimen12pt),
                  SkeletonWidget(
                    width: context.width * 0.25,
                  ),
                  const SizedBox(height: AppDimens.widgetDimen8pt),
                  Row(
                    children: [
                      const SkeletonWidget(
                        height: AppDimens.widgetDimen8pt,
                        width: AppDimens.widgetDimen8pt,
                      ),
                      const SizedBox(width: AppDimens.widgetDimen4pt),
                      SkeletonWidget(
                        height: AppDimens.widgetDimen8pt,
                        width: context.width * 0.2,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.widgetDimen12pt),
                  SkeletonWidget(
                    width: context.width,
                  ),
                  const SizedBox(height: AppDimens.widgetDimen4pt),
                  SkeletonWidget(
                    width: context.width * 0.5,
                  ),
                  const SizedBox(height: AppDimens.widgetDimen12pt),
                  Wrap(
                    spacing: AppDimens.spacingSmall,
                    children: List.generate(
                      2,
                      (index) => SkeletonWidget(
                        width: context.width * 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.widgetDimen12pt),
                  Row(
                    children: [
                      const SkeletonWidget(
                        height: AppDimens.widgetDimen24pt,
                        width: AppDimens.widgetDimen24pt,
                      ),
                      const SizedBox(width: AppDimens.widgetDimen8pt),
                      SkeletonWidget(
                        height: AppDimens.widgetDimen8pt,
                        width: context.width * 0.2,
                      ),
                      const SizedBox(width: AppDimens.widgetDimen16pt),
                      const SizedBox(
                        height: AppDimens.widgetDimen10pt,
                        child: CustomDividerVertical(
                          color: AppColors.grayishBlue,
                          width: AppDimens.widgetDimen2pt,
                        ),
                      ),
                      const SizedBox(width: AppDimens.widgetDimen16pt),
                      const SkeletonWidget(
                        height: AppDimens.widgetDimen24pt,
                        width: AppDimens.widgetDimen24pt,
                      ),
                      const SizedBox(width: AppDimens.widgetDimen8pt),
                      SkeletonWidget(
                        height: AppDimens.widgetDimen8pt,
                        width: context.width * 0.2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
