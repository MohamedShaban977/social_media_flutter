import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/utils/app_util.dart';
import 'package:hauui_flutter/features/main_layout/data/models/check_update_model.dart';
import 'package:hauui_flutter/features/main_layout/data/repositories/check_update_version_repository.dart';

class MainLayoutViewModel {
  static final checkUpdateVersionProvider =
      StateNotifierProvider<CheckUpdateVersionNotifier, AsyncValue<CheckUpdateModel?>>((ref) {
    return CheckUpdateVersionNotifier(const AsyncValue.loading());
  });
  static final bottomTabsIndex =
      StateNotifierProvider<BottomTabsIndexNotifier, int>((ref) => BottomTabsIndexNotifier(0));
}

class BottomTabsIndexNotifier extends StateNotifier<int> {
  BottomTabsIndexNotifier(super.state);

  void setIndex(int index) => state = index;
}

class CheckUpdateVersionNotifier extends StateNotifier<AsyncValue<CheckUpdateModel?>> {
  CheckUpdateVersionNotifier(super._state);

  Future<void> checkUpdateVersion() async {
    state = const AsyncValue.loading();

    final buildNumber = (await AppUtil.getAppInfo()).buildNumber;
    final platform = navigatorKey.currentContext!.platform.name;

    final result = await getIt<CheckUpdateVersionRepository>().checkUpdateVersion(
      platform: platform,
      buildNumber: buildNumber,
    );

    result.fold(
      (error) => state = AsyncValue.error(
        HandleFailure.mapFailureToMsg(error),
        StackTrace.current,
      ),
      (response) {
        state = AsyncValue.data(response.data);
      },
    );
  }
}
