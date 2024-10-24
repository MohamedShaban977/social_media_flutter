import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/hashtag_model.dart';
import 'package:hauui_flutter/core/models/hobby_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/features/post_creation/data/repositories/post_creation_repository.dart';

class PostCreationViewModel {
  static final latProvider = StateProvider.autoDispose<double?>(
    (ref) => null,
  );
  static final lngProvider = StateProvider.autoDispose<double?>(
    (ref) => null,
  );
  static final selectedLevelIdProvider = StateProvider.autoDispose<int?>(
    (ref) => null,
  );
  static final videoLinksProvider = StateProvider.autoDispose<List<String>>(
    (ref) => [],
  );
  static final suggestedHashtagsProvider = NotifierProvider<SuggestedHashtagsNotifier, AsyncValue<List<HashtagModel>>>(
    () => SuggestedHashtagsNotifier(),
  );
  static final suggestedHashtagsPageNumberProvider = StateProvider<int>(
    (ref) => ApiConstants.firstPage,
  );
  static final isLastSuggestedHashtagsPageProvider = StateProvider<bool>(
    (ref) => false,
  );
  static final inputHashtagsProvider = StateProvider.autoDispose<String>(
    (ref) => '',
  );
  static final selectedHobbiesProvider = StateProvider.autoDispose<List<HobbyModel>>(
    (ref) => [],
  );
}

class SuggestedHashtagsNotifier extends Notifier<AsyncValue<List<HashtagModel>>> {
  @override
  AsyncValue<List<HashtagModel>> build() => const AsyncValue.data([]);

  String? keyword;

  Future<void> getSuggestedHashtags({
    int? suggestedHashtagsPageNumber,
    required String keyWord,
  }) async {
    final pageNumber = suggestedHashtagsPageNumber ??
        ref.read(
          PostCreationViewModel.suggestedHashtagsPageNumberProvider,
        );
    if (pageNumber == ApiConstants.firstPage) state = const AsyncValue.loading();
    if (!ref.read(PostCreationViewModel.isLastSuggestedHashtagsPageProvider) || pageNumber == ApiConstants.firstPage) {
      final result = await getIt<PostCreationRepository>().getSuggestedHashtags(
        pageNumber: pageNumber!,
        keyWord: keyWord,
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
              pageNumber == ApiConstants.firstPage ? response.data ?? [] : [...state.value ?? [], ...?response.data]);
          ref.read(PostCreationViewModel.suggestedHashtagsPageNumberProvider.notifier).state = pageNumber + 1;
          ref.read(PostCreationViewModel.isLastSuggestedHashtagsPageProvider.notifier).state =
              (response.data ?? []).length < ApiConstants.defaultPageSize;
        },
      );
    }
  }
}
