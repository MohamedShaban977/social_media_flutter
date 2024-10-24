import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/event_scope.dart';
import 'package:hauui_flutter/core/constants/enums/event_type.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';
import 'package:hauui_flutter/features/events/data/models/joiners_event_model.dart';
import 'package:hauui_flutter/features/events/data/repositories/event_repository.dart';

class EventsViewModel {
  //  Posts list
  static final eventsProvider = NotifierProvider<EventsNotifier, AsyncValue<List<EventModel>>>(
    () => EventsNotifier(),
  );

  static final eventDetailsProvider = NotifierProvider<EventDetailsNotifier, AsyncValue<EventModel?>>(
    () => EventDetailsNotifier(),
  );

  static final joinOrLeaveEventsProvider = NotifierProvider<JoinOrLeaveEventsNotifier, AsyncValue<bool>>(
    () => JoinOrLeaveEventsNotifier(),
  );
  static final eventsForYouPageNumberProvider = StateProvider<int>((ref) => ApiConstants.firstPage);
  static final isLastEventsForYouPageProvider = StateProvider<bool>((ref) => false);

  static final yourEventsPageNumberProvider = StateProvider<int>((ref) => ApiConstants.firstPage);
  static final isLastYourEventsPageProvider = StateProvider<bool>((ref) => false);
  static final selectedScopeProvider = StateProvider<EventScope>((ref) => EventScope.going);

  static final discoverEventsPageNumberProvider = StateProvider<int>((ref) => ApiConstants.firstPage);
  static final isLastDiscoverEventsPageProvider = StateProvider<bool>((ref) => false);
  static final latitudeProvider = StateProvider<double?>((ref) => null);
  static final longitudeProvider = StateProvider<double?>((ref) => null);
  static final indexEventProvider = StateProvider<int>((ref) => -1);

  static final youMayLikeEventsProvider = NotifierProvider<YouMayLikeEventsNotifier, AsyncValue<List<EventModel>>>(
    () => YouMayLikeEventsNotifier(),
  );
  static final youMayLikeEventsPageNumberProvider = StateProvider<int>((ref) => ApiConstants.firstPage);
  static final isLastYouMayLikeEventsPageProvider = StateProvider<bool>((ref) => false);

  /* joinersEvents*/
  static final joinersEventsProvider = NotifierProvider<JoinersEventsNotifier, AsyncValue<JoinersEventModel>>(
    () => JoinersEventsNotifier(),
  );
  static final joinersEventsPageNumberProvider = StateProvider<int>((ref) => ApiConstants.firstPage);
  static final isLastJoinersEventsPageProvider = StateProvider<bool>((ref) => false);
  static final currentIndexJoinerProvider = StateProvider<int?>((ref) => null);

  static onLocationGranted({required WidgetRef ref, required LatLng latLng}) {
    final latitude = ref.read(EventsViewModel.latitudeProvider.notifier).update((state) => state = latLng.latitude);
    final longitude = ref.read(EventsViewModel.longitudeProvider.notifier).update((state) => state = latLng.longitude);

    ref.read(EventsViewModel.eventsProvider.notifier).getDiscoverEvents(
          discoverEventsPageNumber: ApiConstants.firstPage,
          lat: latitude,
          long: longitude,
        );
  }
}

class EventsNotifier extends Notifier<AsyncValue<List<EventModel>>> {
  @override
  AsyncValue<List<EventModel>> build() => const AsyncValue.loading();

  Future<void> getEventsForYou({int? eventsForYouPageNumber}) async {
    final pageNumber = eventsForYouPageNumber ?? ref.read(EventsViewModel.eventsForYouPageNumberProvider);
    if (pageNumber == ApiConstants.firstPage) state = const AsyncValue.loading();
    if (!ref.read(EventsViewModel.isLastEventsForYouPageProvider) || pageNumber == ApiConstants.firstPage) {
      final result = await getIt<EventRepository>().getEventForYou(pageNumber!);

      result.fold(
        (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
        (response) {
          state = AsyncValue.data(
              pageNumber == ApiConstants.firstPage ? response.data ?? [] : [...state.value ?? [], ...?response.data]);
          ref.read(EventsViewModel.eventsForYouPageNumberProvider.notifier).state = pageNumber + 1;
          ref.read(EventsViewModel.isLastEventsForYouPageProvider.notifier).state =
              (response.data ?? []).length < ApiConstants.defaultPageSize;
        },
      );
    }
  }

  Future<void> getYourEvents({required EventScope scope, int? yourEventsPageNumber}) async {
    final pageNumber = yourEventsPageNumber ?? ref.read(EventsViewModel.yourEventsPageNumberProvider);
    if (pageNumber == ApiConstants.firstPage) state = const AsyncValue.loading();
    if (!ref.read(EventsViewModel.isLastYourEventsPageProvider) || pageNumber == ApiConstants.firstPage) {
      final result = await getIt<EventRepository>().getYourEvent(scope.name, pageNumber!);

      result.fold(
        (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
        (response) {
          state = AsyncValue.data(
              pageNumber == ApiConstants.firstPage ? response.data ?? [] : [...state.value ?? [], ...?response.data]);
          ref.read(EventsViewModel.yourEventsPageNumberProvider.notifier).state = pageNumber + 1;
          ref.read(EventsViewModel.isLastYourEventsPageProvider.notifier).state =
              (response.data ?? []).length < ApiConstants.defaultPageSize;
        },
      );
    }
  }

  Future<void> getDiscoverEvents({double? lat, double? long, int? discoverEventsPageNumber}) async {
    final pageNumber = discoverEventsPageNumber ?? ref.read(EventsViewModel.discoverEventsPageNumberProvider);
    if (pageNumber == ApiConstants.firstPage) state = const AsyncValue.loading();
    if (!ref.read(EventsViewModel.isLastDiscoverEventsPageProvider) || pageNumber == ApiConstants.firstPage) {
      final result = await getIt<EventRepository>().getDiscoverEvent(lat ?? 0.0, long ?? 0.0, pageNumber!);

      result.fold(
        (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
        (response) {
          state = AsyncValue.data(
              pageNumber == ApiConstants.firstPage ? response.data ?? [] : [...state.value ?? [], ...?response.data]);
          ref.read(EventsViewModel.discoverEventsPageNumberProvider.notifier).state = pageNumber + 1;
          ref.read(EventsViewModel.isLastDiscoverEventsPageProvider.notifier).state =
              (response.data ?? []).length < ApiConstants.defaultPageSize;
        },
      );
    }
  }

  Future<void> deleteEvent({required int index}) async {
    state = AsyncValue.data(state.value!..removeAt(index));
  }
}

class EventDetailsNotifier extends Notifier<AsyncValue<EventModel?>> {
  @override
  AsyncValue<EventModel> build() => const AsyncValue.loading();

  Future<void> getEventDetails({required int eventId}) async {
    const AsyncValue.loading();

    final result = await getIt<EventRepository>().getEventDetails(eventId);

    result.fold(
      (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
      (response) => state = AsyncValue.data(response.data),
    );
  }

  void updateFollowingUser(int indexUser, bool isFollow) {
    state.value?.latestJoiners![indexUser].isFollowed = isFollow;
    state = AsyncValue.data(state.value!);
  }
}

class JoinOrLeaveEventsNotifier extends Notifier<AsyncValue<bool>> {
  @override
  AsyncValue<bool> build() => const AsyncValue.data(false);

  Future<void> joinEvent({
    required EventType eventType,
    required int eventId,
    required int index,
    isDetailsEvent = false,
  }) async {
    state = const AsyncValue.loading();

    final result = await getIt<EventRepository>().joinEvent(eventId.toString());

    result.fold(
      (error) => {
        state = const AsyncValue.data(false),
        navigatorKey.currentContext!.showToast(message: HandleFailure.mapFailureToMsg(error)),
      },
      (response) {
        state = const AsyncValue.data(true);
        if (EventType.forYou == eventType || EventType.yourEvent == eventType || EventType.discover == eventType) {
          final events = ref.read(EventsViewModel.eventsProvider);
          events.value![index].isJoined = true;
        } else if (EventType.youMayLike == eventType) {
          final events = ref.read(EventsViewModel.youMayLikeEventsProvider);
          events.value![index].isJoined = true;
        }

        if (isDetailsEvent) {
          final event = ref.read(EventsViewModel.eventDetailsProvider);
          event.value!.isJoined = true;
          event.value?.joinersCount = event.value!.joinersCount! + 1;
        }
      },
    );
  }

  Future<void> leaveEvent({
    required int eventId,
    required String userId,
    required EventType eventType,
    required int index,
    isDetailsEvent = false,
  }) async {
    state = const AsyncValue.loading();

    final result = await getIt<EventRepository>().leaveEvent(eventId.toString(), userId);

    result.fold(
      (error) => {
        state = const AsyncValue.data(true),
        navigatorKey.currentContext!.showToast(message: HandleFailure.mapFailureToMsg(error)),
      },
      (response) {
        state = const AsyncValue.data(false);
        if (EventType.forYou == eventType || EventType.yourEvent == eventType || EventType.discover == eventType) {
          final events = ref.read(EventsViewModel.eventsProvider);
          events.value![index].isJoined = false;
        } else if (EventType.youMayLike == eventType) {
          final events = ref.read(EventsViewModel.youMayLikeEventsProvider);
          events.value![index].isJoined = false;
        }

        if (isDetailsEvent) {
          final event = ref.read(EventsViewModel.eventDetailsProvider);
          event.value!.isJoined = false;
          event.value?.joinersCount = event.value!.joinersCount! - 1;
        }
      },
    );
  }

  void set(bool isJoin) => state = AsyncValue.data(isJoin);
}

class JoinersEventsNotifier extends Notifier<AsyncValue<JoinersEventModel>> {
  @override
  AsyncValue<JoinersEventModel> build() => const AsyncValue.loading();

  Future<void> getJoinersEvent({required int eventId, int? joinersEventsPageNumber}) async {
    final pageNumber = joinersEventsPageNumber ?? ref.read(EventsViewModel.joinersEventsPageNumberProvider);
    if (pageNumber == ApiConstants.firstPage) state = const AsyncValue.loading();
    if (!ref.read(EventsViewModel.isLastJoinersEventsPageProvider) || pageNumber == ApiConstants.firstPage) {
      final result = await getIt<EventRepository>().getJoinersEvent(eventId, pageNumber!);

      result.fold(
        (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
        (response) {
          state = AsyncValue.data(JoinersEventModel(
              joiners: pageNumber == ApiConstants.firstPage
                  ? response.data?.joiners ?? []
                  : [...state.value?.joiners ?? [], ...?response.data?.joiners],
              totalCount: response.data?.totalCount));
          ref.read(EventsViewModel.joinersEventsPageNumberProvider.notifier).state = pageNumber + 1;
          ref.read(EventsViewModel.isLastJoinersEventsPageProvider.notifier).state =
              (response.data?.joiners ?? []).length < ApiConstants.defaultPageSize;
        },
      );
    }
  }
}

class YouMayLikeEventsNotifier extends Notifier<AsyncValue<List<EventModel>>> {
  @override
  AsyncValue<List<EventModel>> build() => const AsyncValue.loading();

  Future<void> getYouMayLikeEvent({required int eventId, int? youMayLikeEventsPageNumber}) async {
    final pageNumber = youMayLikeEventsPageNumber ?? ref.read(EventsViewModel.youMayLikeEventsPageNumberProvider);
    if (pageNumber == ApiConstants.firstPage) state = const AsyncValue.loading();
    if (!ref.read(EventsViewModel.isLastYouMayLikeEventsPageProvider) || pageNumber == ApiConstants.firstPage) {
      final result = await getIt<EventRepository>().getYouMayLikeEvent(eventId, pageNumber!);

      result.fold(
        (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
        (response) {
          state = AsyncValue.data(
              pageNumber == ApiConstants.firstPage ? response.data ?? [] : [...state.value ?? [], ...?response.data]);
          ref.read(EventsViewModel.youMayLikeEventsPageNumberProvider.notifier).state = pageNumber + 1;
          ref.read(EventsViewModel.isLastYouMayLikeEventsPageProvider.notifier).state =
              (response.data ?? []).length < ApiConstants.defaultPageSize;
        },
      );
    }
  }
}
