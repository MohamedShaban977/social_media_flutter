import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/filter.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/features/on_boarding/data/repositories/on_boarding_repository.dart';
import 'package:hauui_flutter/features/on_boarding/data/requests_bodies/filter_request_body.dart';

class FollowTopUsersViewModel {
  static final getTopUsersProvider =
      NotifierProvider<TopUsersNotifier, AsyncValue<List<UserModel>>>(() => TopUsersNotifier());

  static final followUserProvider = StateNotifierProvider<FollowNotifier, AsyncValue<String?>>((ref) {
    return FollowNotifier(const AsyncValue.data(null));
  });
  static final unfollowUserProvider = StateNotifierProvider<UnfollowNotifier, AsyncValue<String?>>((ref) {
    return UnfollowNotifier(const AsyncValue.data(null));
  });

  static final topUserPageNumberProvider = StateProvider<int>((ref) => ApiConstants.firstPage);

  static final isLastTopUserPageProvider = StateProvider<bool>((ref) => false);
}

class TopUsersNotifier extends Notifier<AsyncValue<List<UserModel>>> {
  @override
  AsyncValue<List<UserModel>> build() => const AsyncValue.loading();

  Future<void> getTopUsers({
    int? userPageNumber,
  }) async {
    final pageNumber = userPageNumber ?? ref.read(FollowTopUsersViewModel.topUserPageNumberProvider);
    if (pageNumber == ApiConstants.firstPage) state = const AsyncValue.loading();

    if (!ref.read(FollowTopUsersViewModel.isLastTopUserPageProvider) || pageNumber == ApiConstants.firstPage) {
      final result = await getIt<OnboardingRepository>().getTopUsers(FilterRequestBody(
        filter: Filter.top.name,
        page: pageNumber!,
        perPage: ApiConstants.defaultPageSize,
      ));

      result.fold(
        (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
        (response) {
          state = AsyncValue.data(
              pageNumber == ApiConstants.firstPage ? response.data ?? [] : [...state.value ?? [], ...?response.data]);
          ref.read(FollowTopUsersViewModel.topUserPageNumberProvider.notifier).state = pageNumber + 1;
          ref.read(FollowTopUsersViewModel.isLastTopUserPageProvider.notifier).state =
              (response.data ?? []).length < ApiConstants.defaultPageSize;
        },
      );
    }
  }

  void updateFollowingUser(int indexUser, bool isFollow) {
    if (isFollow) {
      state.value?[indexUser].followersCount = (state.value?[indexUser].followersCount ?? 0) + 1;
    } else {
      state.value?[indexUser].followersCount = (state.value?[indexUser].followersCount ?? 0) - 1;
    }
    state.value?[indexUser].isFollowed = isFollow;
    state = AsyncValue.data(state.value!);
  }

  clearUsers() {
    state = const AsyncValue.data([]);
    state = const AsyncValue.loading();
  }
}

class FollowNotifier extends StateNotifier<AsyncValue<String?>> {
  FollowNotifier(super._state);

  Future<void> followUser(int followedId) async {
    state = const AsyncValue.loading();

    final result = await getIt<OnboardingRepository>().followUser(followedId);

    result.fold(
      (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
      (response) => state = AsyncValue.data(response.data ?? ''),
    );
  }
}

class UnfollowNotifier extends StateNotifier<AsyncValue<String?>> {
  UnfollowNotifier(super._state);

  Future<void> unfollowUser(int unfollowedId) async {
    state = const AsyncValue.loading();

    final result = await getIt<OnboardingRepository>().unfollowUser(unfollowedId);

    result.fold(
      (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
      (response) => state = AsyncValue.data(response.data ?? ''),
    );
  }
}
