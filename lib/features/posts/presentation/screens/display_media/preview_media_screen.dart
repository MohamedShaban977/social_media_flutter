import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/account_mode.dart';
import 'package:hauui_flutter/core/constants/enums/image_shape.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/extensions/date_time_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/core/constants/enums/media_type.dart';
import 'package:hauui_flutter/features/posts/presentation/screens/posts_list/posts_view_model.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_video_player_screen.dart';
import 'package:hauui_flutter/features/authentication/account_view_model.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/bottom_sheet/layout_login_with_bottom_sheet.dart';
import 'package:hauui_flutter/features/posts/data/models/post_models/post_model.dart';
import 'package:hauui_flutter/features/posts/presentation/bottom_sheets/cell_settings_bottom_sheet.dart';
import 'package:hauui_flutter/features/posts/presentation/screens/display_media/preview_media_view_model.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/post_actions_widget.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class PreviewMediaScreen extends ConsumerStatefulWidget {
  const PreviewMediaScreen({
    super.key,
    required this.post,
    required this.onLike,
    required this.onSave,
    required this.resetList,
  });

  final PostModel post;
  final void Function(int totalCount)? onLike;
  final void Function()? onSave;
  final void Function()? resetList;

  @override
  ConsumerState<PreviewMediaScreen> createState() => _PreviewMediaScreenState();
}

class _PreviewMediaScreenState extends ConsumerState<PreviewMediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.maybePop(context),
          child: const Icon(Icons.arrow_back_ios, color: AppColors.white),
        ),
        actions: [
          InkWell(
            onTap: () => _showSettingsBottomSheet(),
            child: const Padding(
              padding: EdgeInsetsDirectional.only(end: AppDimens.spacingNormal),
              child: Icon(Icons.more_horiz_rounded, color: AppColors.darkGrayishBlue4),
            ),
          )
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final currentIndex = ref.watch(PreviewMediaViewModel.mediaIndexProvider);
                    return InteractiveViewer(
                      child: GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! > 0) {
                            /// Swiping in right direction.
                            if (currentIndex != 0) {
                              ref.read(PreviewMediaViewModel.mediaIndexProvider.notifier).set(currentIndex - 1);
                            }
                          } else {
                            /// Swiping in left direction.
                            if (currentIndex != widget.post.mediaAttributes!.length - 1) {
                              ref.read(PreviewMediaViewModel.mediaIndexProvider.notifier).set(currentIndex + 1);
                            }
                          }
                        },
                        child: (widget.post.mediaAttributes![currentIndex].mediaType == MediaType.image)
                            ? CustomImage.network(
                                src: widget.post.mediaAttributes![currentIndex].mediaLink,
                                fit: BoxFit.fitWidth,
                                imageShape: ImageShape.roundedCorners,
                              )
                            : CustomVideoPlayerScreen(media: widget.post.mediaAttributes![currentIndex]),
                      ),
                    );
                  },
                ),
              ),

              ///   Post actions -like, comment, share and save-
              if (widget.onLike != null && widget.onSave != null) ...[
                ///   Post title and created at.
                Padding(
                  padding: const EdgeInsetsDirectional.all(AppDimens.customSpacing12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.post.title ?? "",
                        style: TextStyleManager.medium(
                          size: AppDimens.textSize16pt,
                          color: AppColors.mostlyDesaturatedDarkBlue,
                        ),
                      ),
                      Text(
                        widget.post.createdAt!.formatFullDateTime(context.locale.languageCode),
                        style: TextStyleManager.medium(
                          size: AppDimens.textSize12pt,
                          color: AppColors.mostlyDesaturatedDarkBlue,
                        ),
                      ),
                    ],
                  ),
                ),

                ///   Post actions -like, comment, share and save-
                const CustomDividerHorizontal(
                  color: AppColors.lightGrayishBlueOpacity42,
                  thickness: AppDimens.dividerThickness0Point5pt,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: AppDimens.customSpacing20),
                  child: Consumer(
                    builder: (context, provider, child) {
                      return PostActionsWidget(
                          post: ref.watch(PreviewMediaViewModel.postProvider) ?? widget.post,
                          onLike: widget.onLike!,
                          onSave: widget.onSave!,
                          resetList: widget.resetList!);
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsBottomSheet() {
    (ref.read(AccountViewModel.accountModeProvider) == AccountMode.unauthorized)
        ? navigatorKey.currentContext!.showBottomSheet(widget: const LayoutLoginWithBottomSheet())
        : context.showBottomSheet(
            widget: CellSettingsBottomSheet(
              dynamicLink: widget.post.dynamicLink ?? "",
              postUserName: widget.post.owner?.name ?? "",
              ownerId: widget.post.owner!.id!,
              resetList: widget.resetList!,
              deletePost: () => context.showAdaptiveDialog(
                title: LocaleKeys.deleteThisPost.tr(),
                content: LocaleKeys.byDeleteThisPostYouWillLoseIt.tr(),
                negativeBtnName: LocaleKeys.cancel.tr(),
                positiveBtnName: LocaleKeys.delete.tr(),
                positiveBtnAction: () async {
                  await ref.read(PostsViewModel.postsListProvider.notifier).deletePost(
                        postId: widget.post.id!,
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
