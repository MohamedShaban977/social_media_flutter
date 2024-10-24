import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/features/posts/data/models/cell_setting_item_model.dart';
import 'package:hauui_flutter/features/posts/presentation/screens/posts_list/posts_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:share_plus/share_plus.dart';

class CellSettingsBottomSheet extends StatelessWidget {
  const CellSettingsBottomSheet({
    super.key,
    required this.dynamicLink,
    required this.postUserName,
    required this.ownerId,
    required this.resetList,
    required this.deletePost,
  });

  final String dynamicLink;
  final String postUserName;
  final int ownerId;
  final void Function() resetList;
  final void Function() deletePost;

  @override
  Widget build(BuildContext context) {
    final currentUser = UserExtensions.getCachedUser();
    late final items = [
      /// Share via
      CellSettingItemModel(
        title: LocaleKeys.shareVia.tr(),
        onTap: () => Share.share(dynamicLink),
      ),
      if (currentUser?.id == ownerId) ...[
        /// Edit post
        CellSettingItemModel(
          title: LocaleKeys.editPost.tr(),
          onTap: () {},
        ),

        /// Delete post
        CellSettingItemModel(
          title: LocaleKeys.delete.tr(),
          onTap: deletePost,
        ),
      ] else ...[
        /// Report
        CellSettingItemModel(
          title: LocaleKeys.report.tr(),
          onTap: () {},
        ),

        /// Block
        CellSettingItemModel(
          title: LocaleKeys.block.tr(),
          onTap: () => _showBlockConfirmationDialog(context),
        ),
      ],
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(bottom: AppDimens.spacingXLarge),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius10pt),
        color: AppColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              top: AppDimens.spacingNormal,
              bottom: AppDimens.spacingSmall,
              start: AppDimens.spacingXLarge,
              end: AppDimens.spacingNormal,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      LocaleKeys.setting.tr(),
                      style: TextStyleManager.semiBold(size: AppDimens.textSize16pt),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => navigatorKey.currentState?.pop(),
                  child: const Icon(Icons.close, color: AppColors.darkGrayishBlue),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items
                .map(
                  (item) => InkWell(
                    onTap: () => item.onTap(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomDividerHorizontal(),
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                            vertical: AppDimens.spacingNormal,
                            horizontal: AppDimens.spacingLarge,
                          ),
                          child: Text(
                            item.title,
                            style: TextStyleManager.medium(size: AppDimens.textSize14pt),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  void _showBlockConfirmationDialog(BuildContext context) {
    context.showAdaptiveDialog(
      title: LocaleKeys.blockThisAccount.tr(),
      content: LocaleKeys.youWantToBlock.tr(args: [postUserName]),
      negativeBtnName: LocaleKeys.cancel.tr(),
      positiveBtnName: LocaleKeys.block.tr(),
      positiveBtnAction: () async => await _blockUser(context),
    );
  }

  Future<void> _blockUser(BuildContext context) async {
    await PostsViewModel.blockUser(
      userId: ownerId,
      onFailure: (error) => context.showToast(message: error),
      onSuccess: (message) => context.showToast(message: message),
    );
    Navigator.of(context).pop();
    resetList();
  }
}
