import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/post_type.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/features/posts/data/models/post_models/post_model.dart';
import 'package:hauui_flutter/features/posts/data/repositories/posts_repository.dart';

class PostsViewModel {
  //  Posts list
  static final postsListProvider =
      NotifierProvider<PostsListNotifier, AsyncValue<List<PostModel>>>(() => PostsListNotifier());
  static final likedPostIdProvider = StateProvider<int?>((ref) => null);
  static final savedPostIdProvider = StateProvider<int?>((ref) => null);

  static Future<void> likePost({
    required String postId,
    required void Function(String error) onFailure,
    required void Function(int totalCount, String message) onSuccess,
  }) async {
    final result = await getIt<PostsRepository>().likePost(postId: postId);
    result.fold(
      (error) => onFailure(HandleFailure.mapFailureToMsg(error)),
      (response) => onSuccess(response.data?['total_count'] ?? 0, response.data?['message'] ?? ""),
    );
  }

  static Future<void> savePost({
    required String postId,
    required String userId,
    required void Function(String error) onFailure,
    required void Function(String message) onSuccess,
  }) async {
    final result = await getIt<PostsRepository>().savePost(postId: postId, userId: userId);
    result.fold(
      (error) => onFailure(HandleFailure.mapFailureToMsg(error)),
      (response) => onSuccess(response.data?.message ?? ""),
    );
  }

  static Future<void> blockUser({
    required int userId,
    required void Function(String error) onFailure,
    required void Function(String message) onSuccess,
  }) async {
    final result = await getIt<PostsRepository>().blockUser(userId: userId);
    result.fold(
      (error) => onFailure(error.error ?? ""),
      (response) => onSuccess(response.data!.message ?? ""),
    );
  }

  static Future<void> unBlockUser({
    required String postId,
    required void Function(String error) onFailure,
    required void Function(String message) onSuccess,
  }) async {}
}

class PostsListNotifier extends Notifier<AsyncValue<List<PostModel>>> {
  @override
  AsyncValue<List<PostModel>> build() => const AsyncValue.loading();

  bool _isLastPage = false;
  int _pageNumber = ApiConstants.firstPage;

  bool isLastPage() => _isLastPage;

  Future<void> getPostsList({
    bool refresh = false,
    int? eventId,
    int? hobbyId,
    int? userId,
    required PostType type,
  }) async {
    if (refresh) {
      _pageNumber = ApiConstants.firstPage;
      _isLastPage = false;
      state = const AsyncValue.loading();
    }
    if ((!_isLastPage) || refresh) {
      final result = type == PostType.forYou
          ? await getIt<PostsRepository>().getPostsList(
              pageNumber: _pageNumber,
              eventId: eventId,
              hobbyId: hobbyId,
              userId: userId,
            )
          : await getIt<PostsRepository>().getPopularPostsList(pageNumber: _pageNumber);

      result.fold(
        (error) {
          state = AsyncValue.error(
            error,
            StackTrace.fromString(HandleFailure.mapFailureToMsg(error)),
          );
        },
        (response) {
          state = AsyncValue.data(
              _pageNumber == ApiConstants.firstPage ? response.data ?? [] : [...state.value ?? [], ...?response.data]);
          _isLastPage = (response.data ?? []).length < ApiConstants.defaultPageSize;
          _pageNumber = _pageNumber + 1;
        },
      );
    }
  }

  void updateLikesCount(int newCount, int index) {
    state.value![index] = state.value![index].copyWith(likesCount: newCount, isLiked: !state.value![index].isLiked);
    state = AsyncValue.data(state.value!);
  }

  void updateSaveState(int index) {
    state.value![index] = state.value![index].copyWith(isSaved: !state.value![index].isSaved);
    state = AsyncValue.data(state.value!);
  }

  void removePost(int postId) =>
      state = AsyncValue.data((state.value ?? []).where((post) => post.id != postId).toList());

  Future<void> deletePost({
    required int postId,
    required void Function(String error) onFailure,
    required void Function(String message) onSuccess,
  }) async {
    final result = await getIt<PostsRepository>().deletePost(postId: postId);
    result.fold(
      (error) => onFailure(error.error ?? ""),
      (response) {
        removePost(postId);
        onSuccess(response.data?.message ?? "");
      },
    );
  }
}
