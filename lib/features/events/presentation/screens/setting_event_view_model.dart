import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/features/events/data/repositories/event_repository.dart';

class SettingEventViewModel {
  static Future<void> saveUnsaveEvent({
    required int eventId,
    required void Function(String successMassage) onSuccess,
    required void Function(String errorMassage) onFail,
  }) async {
    final response = await getIt<EventRepository>().saveUnsaveEvent(eventId);
    response.fold(
      (error) => onFail(HandleFailure.mapFailureToMsg(error)),
      (response) => onSuccess('${response.data?.message}'),
    );
  }

  static Future<void> deleteEvent({
    required int eventId,
    required void Function(String successMassage) onSuccess,
    required void Function(String errorMassage) onFail,
  }) async {
    final response = await getIt<EventRepository>().deleteEvent(eventId);
    response.fold(
      (error) => onFail(HandleFailure.mapFailureToMsg(error)),
      (response) => onSuccess('${response.data?.message}'),
    );
  }

  static Future<void> hiddenEvents({
    required int eventId,
    required void Function(String successMassage) onSuccess,
    required void Function(String errorMassage) onFail,
  }) async {
    final response = await getIt<EventRepository>().hiddenEvents(eventId);
    response.fold(
      (error) => onFail(HandleFailure.mapFailureToMsg(error)),
      (response) => onSuccess('${response.data?.message}'),
    );
  }

  static Future<void> reportedEvents({
    required int eventId,
    required int reportReasonId,
    required void Function(String successMassage) onSuccess,
    required void Function(String errorMassage) onFail,
  }) async {
    final response = await getIt<EventRepository>().reportedEvents(reportReasonId, eventId);
    response.fold(
      (error) => onFail(HandleFailure.mapFailureToMsg(error)),
      (response) => onSuccess('${response.data?.message}'),
    );
  }

  static final reportReasonEventProvider =
      NotifierProvider<ReportReasonEventNotifier, AsyncValue<List<IntKeyStingValueModel>?>>(
    () => ReportReasonEventNotifier(),
  );
}

class ReportReasonEventNotifier extends Notifier<AsyncValue<List<IntKeyStingValueModel>?>> {
  @override
  AsyncValue<List<IntKeyStingValueModel>> build() => const AsyncValue.loading();

  Future<void> getReportReasonEvent() async {
    const AsyncValue.loading();

    final result = await getIt<EventRepository>().getReportReasonEvent();

    result.fold(
      (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
      (response) => state = AsyncValue.data(response.data),
    );
  }
}
