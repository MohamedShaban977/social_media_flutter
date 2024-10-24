import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/account_mode.dart';
import 'package:hauui_flutter/core/constants/enums/post_level.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/extensions/date_time_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/utils/url_util.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/authentication/account_view_model.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/bottom_sheet/layout_login_with_bottom_sheet.dart';
import 'package:hauui_flutter/features/posts/data/models/post_models/post_model.dart';
import 'package:hauui_flutter/features/posts/presentation/bottom_sheets/cell_settings_bottom_sheet.dart';
import 'package:hauui_flutter/features/posts/presentation/screens/posts_list/posts_view_model.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/post_actions_widget.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/post_display_media.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/post_level_widget.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/post_steps_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class CellPost extends ConsumerWidget {
  const CellPost({
    super.key,
    required this.post,
    this.enableActions = true,
    required this.onLike,
    required this.onSave,
    required this.resetList,
  });

  final PostModel post;
  final bool enableActions;
  final void Function(int totalCount) onLike;
  final void Function() onSave;
  final void Function() resetList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: AppDimens.spacingNormal),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Post Header
          Padding(
            padding: const EdgeInsetsDirectional.only(start: AppDimens.spacingNormal, end: AppDimens.spacingNormal),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: () => enableActions
                        ? () {
                            /// TODO: open user profile
                          }
                        : null,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// image
                        CustomImage.network(
                          src: post.owner?.imageUrl,
                          height: AppDimens.widgetDimen48pt,
                          width: AppDimens.widgetDimen48pt,
                          errorPlaceholder: AppSvg.icPlaceholderUser,
                        ),
                        const SizedBox(width: AppDimens.widgetDimen16pt),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// name
                              Text(
                                '${post.owner?.name ?? ""}.',
                                style: TextStyleManager.semiBold(size: AppDimens.textSize14pt),
                              ),
                              const SizedBox(height: AppDimens.widgetDimen4pt),

                              /// level
                              PostLevelWidget.list(
                                level: post.level?.name ?? "",
                                levelEnum: PostLevelExtensions.tryParse(post.level!.name!.toLowerCase())!,
                              ),
                              const SizedBox(height: AppDimens.widgetDimen4pt),

                              /// created at time
                              Text(
                                LocaleKeys.postTime.tr(args: [
                                  post.createdAt!.getDayName(),
                                  post.createdAt!.getFormattedDateTime(
                                    context.locale.languageCode,
                                    AppConstants.patternHMMA,
                                  )
                                ]),
                                style: TextStyleManager.regular(
                                  size: AppDimens.textSize10pt,
                                  color: AppColors.grayishBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppDimens.widgetDimen16pt),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _showSettingBottomSheet(context, ref),
                  child: const Icon(Icons.more_horiz_rounded, color: AppColors.darkGrayishBlue4),
                )
              ],
            ),
          ),
          const SizedBox(height: AppDimens.widgetDimen16pt),

          ///Post title and description
          Padding(
            padding: const EdgeInsetsDirectional.only(start: AppDimens.spacingNormal, end: AppDimens.spacingNormal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((post.title ?? "").isNotEmpty)
                  Text(post.title ?? "", style: TextStyleManager.medium(size: AppDimens.textSize16pt)),
                if ((post.description ?? "").isNotEmpty)
                  Linkify(
                    onOpen: (link) => UrlUtil.launchURL(url: link.url),
                    text: post.description ?? "",
                    style: TextStyleManager.regular(size: AppDimens.textSize14pt),
                    linkStyle: TextStyleManager.regular(
                      size: AppDimens.textSize14pt,
                      color: AppColors.vividCyan,
                      textDecoration: TextDecoration.underline,
                      decorationColor: AppColors.vividCyan,
                    ),
                  ),

                ///Post hashtags
                if ((post.hashtags ?? []).isNotEmpty)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: AppDimens.spacingSmall),
                    child: Wrap(
                      children: (post.hashtags ?? [])
                          .map((hashtag) => InkWell(
                                onTap: () => enableActions
                                    ? () {
                                        /// TODO: open hashtag
                                      }
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.only(end: AppDimens.customSpacing4),
                                  child: Text(
                                    LocaleKeys.hashtag.tr(args: [hashtag.name!]),
                                    style: TextStyleManager.bold(size: AppDimens.textSize14pt),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),

          ///Post hobbies
          if ((post.hobbies ?? []).isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.only(
                top: AppDimens.spacingNormal,
                start: AppDimens.spacingNormal,
                end: AppDimens.spacingNormal,
              ),
              child: Wrap(
                children: (post.hobbies ?? [])
                    .map((hashtag) => InkWell(
                          onTap: () => enableActions
                              ? () {
                                  /// TODO: open hashtag
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(end: AppDimens.spacingSmall),
                            child: Container(
                                height: AppDimens.widgetDimen24pt,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppDimens.cornerRadius4pt),
                                    color: AppColors.lightGrayishBlueOpacity42),
                                child: Padding(
                                  padding: const EdgeInsets.all(AppDimens.customSpacing4),
                                  child: Text(hashtag.hobby?.name ?? "",
                                      style: TextStyleManager.regular(size: AppDimens.textSize12pt)),
                                )),
                          ),
                        ))
                    .toList(),
              ),
            ),

          ///Post Media
          if ((post.mediaAttributes ?? []).isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.only(top: AppDimens.spacingNormal),
              child: PostDisplayMedia(post: post, onLike: onLike, onSave: onSave, resetList: resetList),
            ),

          /// Post Steps
          if ((post.stepsAttributes ?? []).isNotEmpty) ...[
            PostStepsWidget(steps: post.stepsAttributes!),
            const CustomDividerHorizontal(
              color: AppColors.lightGrayishBlue2,
              thickness: AppDimens.dividerThickness0Point5pt,
            ),
          ],

          ///   Post actions -like, comment, share and save-
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: AppDimens.spacingNormal),
            child: PostActionsWidget(
              post: post,
              onLike: onLike,
              onSave: onSave,
              resetList: resetList,
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingBottomSheet(BuildContext context, WidgetRef ref) {
    (ref.read(AccountViewModel.accountModeProvider) == AccountMode.unauthorized)
        ? navigatorKey.currentContext!.showBottomSheet(widget: const LayoutLoginWithBottomSheet())
        : context.showBottomSheet(
            widget: CellSettingsBottomSheet(
              dynamicLink: post.dynamicLink ?? "",
              postUserName: post.owner?.name ?? "",
              ownerId: post.owner!.id!,
              resetList: resetList,
              deletePost: () => context.showAdaptiveDialog(
                title: LocaleKeys.deleteThisPost.tr(),
                content: LocaleKeys.byDeleteThisPostYouWillLoseIt.tr(),
                negativeBtnName: LocaleKeys.cancel.tr(),
                positiveBtnName: LocaleKeys.delete.tr(),
                positiveBtnAction: () async {
                  await ref.read(PostsViewModel.postsListProvider.notifier).deletePost(
                        postId: post.id!,
                        onFailure: (error) => context.showToast(message: error),
                        onSuccess: (message) => context.showToast(message: message),
                      );
                  Navigator.of(navigatorKey.currentContext!).pop();
                },
              ),
            ),
          );
  }
}
