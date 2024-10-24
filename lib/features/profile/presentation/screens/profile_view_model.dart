import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/features/profile/data/repositories/profile_repository.dart';

class ProfileViewModel {
  static final profileProvider = NotifierProvider<ProfileNotifier, AsyncValue<UserModel?>>(
    () => ProfileNotifier(),
  );
}

class ProfileNotifier extends Notifier<AsyncValue<UserModel?>> {
  @override
  AsyncValue<UserModel> build() => const AsyncValue.loading();

  Future<void> getProfile({
    required int userId,
  }) async {
    state = const AsyncValue.loading();
    final result = await getIt<ProfileRepository>().getProfile(
      userId: userId,
    );
    result.fold(
      (error) => state = AsyncValue.error(
        HandleFailure.mapFailureToMsg(
          error,
        ),
        StackTrace.current,
      ),
      (response) {
        state = AsyncValue.data(
          response.data,
        );
      },
    );
  }
}
