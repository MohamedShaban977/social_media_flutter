import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/features/on_boarding/data/repositories/on_boarding_repository.dart';

class LevelsViewModel {
  static final getLevelsProvider =
      StateNotifierProvider.autoDispose<LevelsNotifier, AsyncValue<List<IntKeyStingValueModel>>>((ref) {
    return LevelsNotifier(const AsyncValue.loading());
  });
}

class LevelsNotifier extends StateNotifier<AsyncValue<List<IntKeyStingValueModel>>> {
  LevelsNotifier(super._state);

  Future<void> getLevelsList() async {
    state = const AsyncValue.loading();

    final result = await getIt<OnboardingRepository>().getLevelsList();

    result.fold(
      (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
      (response) => state = AsyncValue.data(response.data ?? []),
    );
  }
}
