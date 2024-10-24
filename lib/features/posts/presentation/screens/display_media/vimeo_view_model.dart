import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/features/posts/data/repositories/vimeo_repository.dart';
import 'package:riverpod/riverpod.dart';

class VimeoViewModel {
  //  Posts list
  static final vimeoProvider = NotifierProvider<VimeoNotifier, AsyncValue<String>>(() => VimeoNotifier());
}

class VimeoNotifier extends Notifier<AsyncValue<String>> {
  @override
  AsyncValue<String> build() => const AsyncValue.loading();

  Future<void> getVimeoThumbnail({required String videoId}) async {
    final result = await getIt<VimeoRepository>().getVimeoThumbnail(videoId: videoId);

    result.fold(
      (error) {
        state = AsyncValue.error(
          error,
          StackTrace.fromString(HandleFailure.mapFailureToMsg(error)),
        );
      },
      (response) => state = AsyncValue.data(response.data!['thumbnail_url'].toString()),
    );
  }
}
