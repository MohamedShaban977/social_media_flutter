import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/post_creation/presentation/screens/post_creation_view_model.dart';

class CellVideoLink extends ConsumerWidget {
  final int index;

  const CellVideoLink({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            top: AppDimens.spacingSmall,
            end: AppDimens.spacingSmall,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsetsDirectional.all(
              AppDimens.spacingSmall,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                width: AppDimens.borderWidth1pt,
                color: AppColors.darkGray.withOpacity(
                  0.34,
                ),
              ),
            ),
            child: Text(
              ref.read(PostCreationViewModel.videoLinksProvider)[index],
              style: TextStyleManager.regular(
                size: AppDimens.textSize12pt,
              ),
            ),
          ),
        ),
        PositionedDirectional(
          top: AppDimens.zero,
          end: AppDimens.zero,
          child: InkWell(
            onTap: () => _onDeleteTapped(
              ref: ref,
            ),
            child: const CustomImage.svg(
              src: AppSvg.icCloseWhiteRoundedVividPink,
            ),
          ),
        )
      ],
    );
  }

  void _onDeleteTapped({
    required WidgetRef ref,
  }) {
    ref.read(PostCreationViewModel.videoLinksProvider.notifier).update(
          (state) => state = [
            ...state
              ..removeAt(
                index,
              ),
          ],
        );
  }
}
