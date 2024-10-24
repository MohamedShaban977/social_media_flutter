import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/post_creation/presentation/bottom_sheet/add_hashtags_bottom_sheet.dart';
import 'package:hauui_flutter/features/post_creation/presentation/bottom_sheet/add_video_link_bottom_sheet.dart';
import 'package:hauui_flutter/features/post_creation/presentation/screens/post_creation_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class PostMediaOptionsWidget extends ConsumerWidget {
  const PostMediaOptionsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: _onCameraTapped,
          child: const CustomImage.svg(
            src: AppSvg.icCamera,
          ),
        ),
        InkWell(
          onTap: () => _onVideoLinkTapped(
            context: context,
            ref: ref,
          ),
          child: const CustomImage.svg(
            src: AppSvg.icLink,
          ),
        ),
        InkWell(
          onTap: () => _onHashtagTapped(
            context: context,
          ),
          child: const CustomImage.svg(
            src: AppSvg.icHashtag,
          ),
        ),
      ],
    );
  }

  void _onCameraTapped() {}

  void _onVideoLinkTapped({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    if (ref.read(PostCreationViewModel.videoLinksProvider).length < AppConstants.postMediaMax) {
      context.showBottomSheet(
        widget: AddVideoLinkBottomSheet(),
      );
    } else {
      context.showToast(
        message: LocaleKeys.maximumNumberOfSelectedImagesVideosAndLinksIs10.tr(),
      );
    }
  }

  void _onHashtagTapped({
    required BuildContext context,
  }) {
    context.showBottomSheet(
      widget: const AddHashtagsBottomSheet(),
    );
  }
}
