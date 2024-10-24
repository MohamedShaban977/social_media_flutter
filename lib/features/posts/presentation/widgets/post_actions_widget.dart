import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/account_mode.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/features/posts/presentation/screens/display_media/preview_media_view_model.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/authentication/account_view_model.dart';
import 'package:hauui_flutter/features/authentication/login/presentation/bottom_sheet/layout_login_with_bottom_sheet.dart';
import 'package:hauui_flutter/features/posts/data/models/post_models/post_model.dart';
import 'package:hauui_flutter/features/posts/presentation/screens/posts_list/posts_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class PostActionsWidget extends ConsumerWidget {
  PostActionsWidget({
    super.key,
    required this.post,
    required this.onLike,
    required this.onSave,
    required this.resetList,
  });

  /// if you came from preview don't set post as i read it from the state and don't forget to set it before navigate to the screen.
  final PostModel? post;
  final void Function(int totalCount) onLike;
  final void Function() onSave;
  final void Function() resetList;

  PostModel? currentPost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    currentPost = post ?? ref.watch(PreviewMediaViewModel.postProvider);
    return SizedBox(
      height: AppDimens.widgetDimen48pt,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              /// like
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  InkWell(
                    onTap: () async => await _likeAction(context, ref),
                    child: currentPost?.isLiked ?? false
                        ? const CustomImage.svg(src: AppSvg.icLikeFill)
                        : const CustomImage.svg(src: AppSvg.icLike),
                  ),
                  const SizedBox(width: AppDimens.widgetDimen8pt),
                  Text(
                    (currentPost?.likesCount ?? 0) < AppConstants.kCount
                        ? (currentPost?.likesCount ?? 0).toString()
                        : LocaleKeys.countsK.tr(args: [(currentPost?.likesCount ?? 0).toString()]),
                    style: TextStyleManager.regular(
                      size: AppDimens.textSize12pt,
                      color: AppColors.mostlyDesaturatedDarkBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppDimens.widgetDimen24pt),

              /// comments
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const CustomImage.svg(src: AppSvg.icComment),
                  const SizedBox(width: AppDimens.widgetDimen8pt),
                  Text(
                    (currentPost?.commentsCount ?? 0) < AppConstants.kCount
                        ? (currentPost?.commentsCount ?? 0).toString()
                        : LocaleKeys.countsK.tr(args: [(currentPost?.commentsCount ?? 0).toString()]),
                    style: TextStyleManager.regular(
                      size: AppDimens.textSize12pt,
                      color: AppColors.mostlyDesaturatedDarkBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppDimens.widgetDimen24pt),

              /// share
              InkWell(
                onTap: () => _shareAction(ref),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const CustomImage.svg(src: AppSvg.icShare),
                    const SizedBox(width: AppDimens.widgetDimen8pt),
                    Text(
                      (currentPost?.sharesCount ?? 0) < AppConstants.kCount
                          ? (currentPost?.sharesCount ?? 0).toString()
                          : LocaleKeys.countsK.tr(args: [(currentPost?.sharesCount ?? 0).toString()]),
                      style: TextStyleManager.regular(
                        size: AppDimens.textSize12pt,
                        color: AppColors.mostlyDesaturatedDarkBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// save
          InkWell(
            onTap: () async => await _saveAction(context, ref),
            child: currentPost?.isSaved ?? false
                ? const CustomImage.svg(src: AppSvg.icSaveFill)
                : const CustomImage.svg(src: AppSvg.icSave),
          ),
        ],
      ),
    );
  }

  Future<void> _likeAction(BuildContext context, WidgetRef ref) async {
    if (ref.read(AccountViewModel.accountModeProvider) == AccountMode.unauthorized) {
      navigatorKey.currentContext!.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
    } else {
      /// To prevent user clicks until action done.
      if (ref.read(PostsViewModel.likedPostIdProvider) != currentPost?.id) {
        ref.read(PostsViewModel.likedPostIdProvider.notifier).state = currentPost?.id;
        await PostsViewModel.likePost(
          postId: currentPost!.id!.toString(),
          onFailure: (error) => context.showToast(message: error),
          onSuccess: (totalCount, message) {
            onLike(totalCount);
            context.showToast(message: message);
          },
        );
      }
    }
  }

  Future<void> _saveAction(BuildContext context, WidgetRef ref) async {
    if (ref.read(AccountViewModel.accountModeProvider) == AccountMode.unauthorized) {
      navigatorKey.currentContext!.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
    } else {
      /// To prevent user clicks until action done.
      if (ref.read(PostsViewModel.savedPostIdProvider) != currentPost?.id) {
        ref.read(PostsViewModel.savedPostIdProvider.notifier).state = currentPost?.id;
        final user = UserExtensions.getCachedUser();
        if (user != null) {
          await PostsViewModel.savePost(
            userId: user.id!.toString(),
            postId: currentPost!.id!.toString(),
            onFailure: (error) => context.showToast(message: error),
            onSuccess: (message) {
              onSave();
              context.showToast(message: message);
            },
          );
        }
      }
    }
  }

  void _shareAction(WidgetRef ref) {
    if (ref.read(AccountViewModel.accountModeProvider) == AccountMode.unauthorized) {
      navigatorKey.currentContext!.showBottomSheet(widget: const LayoutLoginWithBottomSheet());
    } else {
      /// Share action
    }
  }
}
