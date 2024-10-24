import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/features/event_creation/data/models/timezone_model.dart';
import 'package:hauui_flutter/features/event_creation/data/repositories/event_creation_repository.dart';

class EditDateAndTimeViewModel {
  static final startDateProvider = StateProvider<DateTime?>((ref) => null);
  static final endDateProvider = StateProvider<DateTime?>((ref) => null);
  static final startTimeProvider = StateProvider<TimeOfDay?>((ref) => null);
  static final endTimeProvider = StateProvider<TimeOfDay?>((ref) => null);
  static final selectTimezoneProvider = StateProvider<TimezoneModel?>((ref) => null);

  static final timezonesProvider = NotifierProvider<TimezonesNotifier, AsyncValue<List<TimezoneModel>>>(
    () => TimezonesNotifier(),
  );
}

class TimezonesNotifier extends Notifier<AsyncValue<List<TimezoneModel>>> {
  @override
  AsyncValue<List<TimezoneModel>> build() => const AsyncValue.loading();

  Future<void> getLookupTimezone() async {
    state = const AsyncValue.loading();
    final result = await getIt<EventCreationRepository>().getLookupTimezone();

    result.fold(
      (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
      (response) => state = AsyncValue.data(response.data ?? []),
    );
  }
}
