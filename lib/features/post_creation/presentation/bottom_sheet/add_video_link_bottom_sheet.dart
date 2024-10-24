import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/utils/regex_util.dart';
import 'package:hauui_flutter/core/widgets/common/bottom_sheets/main_bottom_sheet.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_text_field.dart';
import 'package:hauui_flutter/features/post_creation/presentation/screens/post_creation_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class AddVideoLinkBottomSheet extends ConsumerWidget {
  final videoLinkController = TextEditingController();

  AddVideoLinkBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainBottomSheet(
      containerBorderRadius: AppDimens.cornerRadius4pt,
      title: LocaleKeys.addVideoLinks.tr(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: AppDimens.spacingNormal,
              top: AppDimens.spacingLarge,
              end: AppDimens.spacingNormal,
              bottom: AppDimens.spacingXLarge,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: videoLinkController,
                    hintText: LocaleKeys.writeURLHere.tr(),
                    hintStyle: TextStyleManager.medium(
                      size: AppDimens.textSize15pt,
                      color: AppColors.darkGrayishBlue5,
                    ),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: AppDimens.textSize15pt,
                        ),
                    textInputAction: TextInputAction.done,
                    contentPadding: const EdgeInsetsDirectional.symmetric(
                      horizontal: AppDimens.spacingSmall,
                      vertical: AppDimens.customSpacing12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppDimens.spacingSmall,
                  ),
                  child: InkWell(
                    onTap: () => _onAddVideoLinkTapped(
                      context: context,
                      ref: ref,
                    ),
                    child: const CustomImage.svg(
                      src: AppSvg.icAddWhiteSquaredVividPinkLarge,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onAddVideoLinkTapped({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    if (RegexUtil.rxUrl.hasMatch(videoLinkController.text)) {
      ref.read(PostCreationViewModel.videoLinksProvider.notifier).update(
            (state) => state = [
              ...state,
              videoLinkController.text,
            ],
          );
      Navigator.pop(
        context,
      );
    } else {
      context.showToast(
        message: LocaleKeys.invalidLink.tr(),
      );
    }
  }
}
