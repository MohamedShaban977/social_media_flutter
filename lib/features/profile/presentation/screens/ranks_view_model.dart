import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/features/authentication/login/data/models/rank_model.dart';
import 'package:hauui_flutter/features/profile/data/repositories/profile_repository.dart';

class RanksViewModel {
  static final ranksProvider = NotifierProvider<RanksNotifier, AsyncValue<List<RankModel>>>(
    () => RanksNotifier(),
  );
}

class RanksNotifier extends Notifier<AsyncValue<List<RankModel>>> {
  @override
  AsyncValue<List<RankModel>> build() => const AsyncValue.loading();

  Future<void> getRanks() async {
    state = const AsyncValue.loading();
    final result = await getIt<ProfileRepository>().getRanks();
    result.fold(
      (error) => state = AsyncValue.error(
        HandleFailure.mapFailureToMsg(
          error,
        ),
        StackTrace.current,
      ),
      (response) {
        state = AsyncValue.data(
          response.data ?? [],
        );
      },
    );
  }
}
