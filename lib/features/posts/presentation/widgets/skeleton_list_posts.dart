import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/skeleton_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonListPosts extends StatelessWidget {
  const SkeletonListPosts({super.key});

  final dummySubTitle = "Subtitle here";
  final dummyDescription =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. ";

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 6,
        padding: const EdgeInsets.all(AppDimens.spacingNormal),
        itemBuilder: (context, index) {
          return Card(
            surfaceTintColor: AppColors.white,
            child: ListTile(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.ac_unit, size: AppDimens.widgetDimen48pt),
                  const SizedBox(width: AppDimens.widgetDimen16pt),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonWidget(
                          width: context.width * 0.22,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppDimens.customSpacing4),
                          child: SkeletonWidget(
                            width: context.width * 0.2,
                            height: AppDimens.widgetDimen8pt,
                          ),
                        ),
                        SkeletonWidget(
                          width: context.width * 0.2,
                          height: AppDimens.widgetDimen8pt,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimens.widgetDimen8pt),
                  SkeletonWidget(width: context.width),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppDimens.customSpacing4),
                    child: SkeletonWidget(width: context.width),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppDimens.customSpacing4),
                    child: SkeletonWidget(width: context.width),
                  ),
                  SkeletonWidget(width: context.width * 0.4),
                  const SizedBox(height: AppDimens.widgetDimen8pt),
                  SkeletonWidget(
                    height: AppDimens.widgetDimen200pt,
                    width: context.width,
                  ),
                  const SizedBox(height: AppDimens.widgetDimen4pt),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
