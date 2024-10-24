import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/enums/post_type.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_empty_state.dart';
import 'package:hauui_flutter/features/posts/data/models/post_models/post_model.dart';
import 'package:hauui_flutter/features/posts/presentation/screens/display_media/preview_media_view_model.dart';
import 'package:hauui_flutter/features/posts/presentation/screens/posts_list/posts_view_model.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/cell_post.dart';
import 'package:hauui_flutter/features/posts/presentation/widgets/skeleton_list_posts.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class ListPosts extends ConsumerStatefulWidget {
  const ListPosts.forYou({
    super.key,
  }) : postType = PostType.forYou;

  const ListPosts.popular({
    super.key,
  }) : postType = PostType.popular;

  final PostType postType;

  @override
  ConsumerState<ListPosts> createState() => _PostsListWidgetState();
}

class _PostsListWidgetState extends ConsumerState<ListPosts> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getPostsList(refresh: true);
      _handlePagination();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<PostModel>>>(
      PostsViewModel.postsListProvider,
      (previous, next) => next.whenOrNull(
        error: (error, stackTrace) => context.showToast(message: error.toString()),
      ),
    );

    final list = ref.watch(PostsViewModel.postsListProvider);
    return RefreshIndicator(
      onRefresh: () => _getPostsList(refresh: true),
      backgroundColor: AppColors.white,
      child: list.when(
        loading: () => const SkeletonListPosts(),
        error: (_, error) => const SizedBox.shrink(),
        data: (value) => value.isEmpty
            ? CustomEmptyState(title: LocaleKeys.noPosts.tr())
            : ListView.builder(
                padding: EdgeInsets.zero,
                controller: _scrollController,
                itemCount: value.length + 1,
                itemBuilder: (ctx, index) {
                  return (index == value.length)
                      ? ref.read(PostsViewModel.postsListProvider.notifier).isLastPage()
                          ? const SizedBox.shrink()
                          : const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            CellPost(
                              post: value[index],
                              onLike: (count) => onLike(count, index),
                              onSave: () => onSave(index),
                              resetList: () => _getPostsList(refresh: true),
                            ),
                            Container(height: AppDimens.widgetDimen8pt, color: AppColors.lightGrayishBlueOpacity42),
                          ],
                        );
                },
              ),
      ),
    );
  }

  Future<void> _getPostsList({bool refresh = false}) async {
    await ref.read(PostsViewModel.postsListProvider.notifier).getPostsList(refresh: refresh, type: widget.postType);
  }

  void onLike(int count, int index) {
    ref.read(PostsViewModel.postsListProvider.notifier).updateLikesCount(count, index);
    ref.read(PreviewMediaViewModel.postProvider.notifier).state =
        ref.read(PostsViewModel.postsListProvider).value![index];
    ref.read(PostsViewModel.likedPostIdProvider.notifier).state = null;
  }

  void onSave(int index) {
    ref.read(PostsViewModel.postsListProvider.notifier).updateSaveState(index);
    ref.read(PreviewMediaViewModel.postProvider.notifier).state =
        ref.read(PostsViewModel.postsListProvider).value![index];
    ref.read(PostsViewModel.savedPostIdProvider.notifier).state = null;
  }

  void _handlePagination() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _getPostsList();
      }
    });
  }
}
