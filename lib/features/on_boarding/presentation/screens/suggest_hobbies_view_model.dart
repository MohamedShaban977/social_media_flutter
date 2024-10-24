import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/models/hobby_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/on_boarding/data/repositories/on_boarding_repository.dart';
import 'package:hauui_flutter/features/on_boarding/data/requests_bodies/filter_request_body.dart';
import 'package:hauui_flutter/features/on_boarding/data/requests_bodies/suggest_hobby_request_body.dart';

class SuggestHobbiesViewModel {
  static final getSuggestHobbiesProvider =
      StateNotifierProvider<SuggestHobbiesNotifier, AsyncValue<List<HobbyModel>>>((ref) {
    return SuggestHobbiesNotifier(const AsyncValue.data([]));
  });
  static final getSuggestSubHobbiesProvider =
      StateNotifierProvider<SuggestHobbiesNotifier, AsyncValue<List<HobbyModel>>>((ref) {
    return SuggestHobbiesNotifier(const AsyncValue.loading());
  });

  static final selectParentHobbyProvider = StateProvider<HobbyModel?>((ref) => null);

  static final addSuggestHobbiesProvider =
      StateNotifierProvider<AddSuggestHobbiesNotifier, AsyncValue<BaseResponse<String>>>((ref) {
    return AddSuggestHobbiesNotifier(const AsyncValue.loading());
  });
}

class SuggestHobbiesNotifier extends StateNotifier<AsyncValue<List<HobbyModel>>> {
  SuggestHobbiesNotifier(super._state);

  Future<void> getSuggestHobbiesList({required String keyword, int? parentHobby}) async {
    state = const AsyncValue.loading();

    final result = await getIt<OnboardingRepository>().getSuggestHobbies(FilterRequestBody(
      keyword: keyword,
      parentHobby: parentHobby,
      perPage: ApiConstants.pageSize500,
    ));

    result.fold(
      (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
      (response) => state = AsyncValue.data(response.data ?? []),
    );

    if (state.hasError) {
      navigatorKey.currentContext!.showToast(message: state.error.toString());
    }
  }

  void clearSuggestHobbies() => state = const AsyncValue.data([]);
}

class AddSuggestHobbiesNotifier extends StateNotifier<AsyncValue<BaseResponse<String>>> {
  AddSuggestHobbiesNotifier(super._state);

  Future<void> addSuggestHobbies({required SuggestHobbyRequestBody suggestHobbyRequestBody}) async {
    state = const AsyncValue.loading();

    final result = await getIt<OnboardingRepository>().addSuggestHobbies(suggestHobbyRequestBody);

    result.fold(
      (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
      (response) => state = AsyncValue.data(response),
    );
  }
}
