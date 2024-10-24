import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/account_mode.dart';
import 'package:hauui_flutter/core/constants/enums/event_scope.dart';
import 'package:hauui_flutter/core/constants/enums/event_type.dart';
import 'package:hauui_flutter/core/constants/enums/permission_type.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/utils/location_util.dart';
import 'package:hauui_flutter/core/widgets/common/bottom_sheets/permissions_bottom_sheet.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_empty_state.dart';
import 'package:hauui_flutter/features/authentication/account_view_model.dart';
import 'package:hauui_flutter/features/events/data/models/event_model.dart';
import 'package:hauui_flutter/features/events/presentation/screens/events_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

import 'cell_event.dart';
import 'scope_event_button_widget.dart';
import 'skeleton_list_events.dart';

class ListEvents extends ConsumerStatefulWidget {
  const ListEvents.forYou({
    super.key,
  }) : eventType = EventType.forYou;

  const ListEvents.yourEvent({
    super.key,
  }) : eventType = EventType.yourEvent;

  const ListEvents.discover({
    super.key,
  }) : eventType = EventType.discover;

  final EventType eventType;

  @override
  ConsumerState<ListEvents> createState() => _ListEventsWidgetState();
}

class _ListEventsWidgetState extends ConsumerState<ListEvents> with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  final _locationUtil = const LocationUtil();
  bool _shouldRecallGetCurrentLocation = false;
  StreamSubscription<ServiceStatus>? _locationServiceStatusStreamSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getEvents(eventsPageNumber: ApiConstants.firstPage);
      _handlePagination();
      if (widget.eventType == EventType.yourEvent) {
        ref.invalidate(EventsViewModel.selectedScopeProvider);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _shouldRecallGetCurrentLocation) {
      _shouldRecallGetCurrentLocation = false;
      _getCurrentLocation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_locationServiceStatusStreamSubscription != null) {
      LocationUtil.cancelLocationServiceListener(
        locationServiceStatusStreamSubscription: _locationServiceStatusStreamSubscription!,
        onError: (error) => context.showToast(
          message: error.toString(),
        ),
      );
    }
    _scrollController.dispose();
    super.dispose();
  }

  _listen() {
    ref.listen<AsyncValue<List<EventModel>>>(
      EventsViewModel.eventsProvider,
      (previous, next) => next.whenOrNull(
        error: (error, stackTrace) => context.showToast(message: error.toString()),
      ),
    );

    ref.listen<AsyncValue<bool>>(
      EventsViewModel.joinOrLeaveEventsProvider,
      (previous, next) => next.whenOrNull(
        error: (error, stackTrace) => context.showToast(message: error.toString()),
      ),
    );
    ref.listen<EventScope>(
      EventsViewModel.selectedScopeProvider,
      (previous, next) => _getEvents(eventsPageNumber: ApiConstants.firstPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    _listen();

    final eventsState = ref.watch(EventsViewModel.eventsProvider);
    return RefreshIndicator(
      onRefresh: () => _getEvents(eventsPageNumber: ApiConstants.firstPage),
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          if (widget.eventType == EventType.yourEvent) const ScopeEventButtonWidget(),
          Expanded(
            child: eventsState.when(
              loading: () => const SkeletonListEvents(),
              error: (_, error) => const SizedBox.shrink(),
              data: (events) => events.isEmpty
                  ? CustomEmptyState(
                      title: (ref.read(AccountViewModel.accountModeProvider) == AccountMode.unauthorized &&
                              widget.eventType == EventType.yourEvent)
                          ? LocaleKeys.pleaseLoginToContinue.tr()
                          : LocaleKeys.noEvent.tr())
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      controller: _scrollController,
                      itemCount: events.length + 1,
                      itemBuilder: (_, index) => (index == events.length)
                          ? _isLastPageEvents
                              ? const SizedBox.shrink()
                              : const Center(child: CircularProgressIndicator())
                          : CellEvent(
                              event: events[index],
                              eventType: widget.eventType,
                              index: index,
                            ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    await _locationUtil.getCurrentLocation(
      onLocationGranted: (latLng) => _onLocationGranted(latLng: latLng),
      onLocationDeniedForever: _onLocationDeniedForever,
      onLocationServiceDisabled: _onLocationServiceDisabled,
    );
  }

  void _onLocationGranted({required LatLng latLng}) {
    final lat = ref.read(EventsViewModel.latitudeProvider.notifier).update((state) => state = latLng.latitude);
    final lng = ref.read(EventsViewModel.longitudeProvider.notifier).update((state) => state = latLng.longitude);
    logger.i('Location is granted: $lat, $lng');
  }

  Future<void> _onLocationDeniedForever() async {
    context
        .showBottomSheet(
      widget: PermissionsBottomSheet(
        requiredPermissions: const [
          PermissionType.location,
        ],
      ),
    )
        .then(
      (isAppSettingsScreenOpened) {
        if (isAppSettingsScreenOpened != null) {
          _shouldRecallGetCurrentLocation = isAppSettingsScreenOpened;
        }
      },
    );
  }

  void _onLocationServiceDisabled() {
    context.showAdaptiveDialog(
      title: LocaleKeys.forBetterExperienceTurnOnDeviceLocation.tr(),
      negativeBtnName: LocaleKeys.noThanks.tr(),
      positiveBtnName: LocaleKeys.openSettings.tr(),
      positiveBtnAction: () async {
        await _openSettingsPressed();
      },
    );
  }

  Future<void> _openSettingsPressed() async {
    _locationServiceStatusStreamSubscription = await _locationUtil.openLocationSettings(
      onAndroidLocationServiceEnabled: (latLng) => _onLocationGranted(latLng: latLng),
      onIOSLocationServiceEnabled: () async => await _getCurrentLocation(),
    );
  }

  Future<void> _getEvents({int? eventsPageNumber}) async {
    if (widget.eventType == EventType.forYou) {
      await ref.read(EventsViewModel.eventsProvider.notifier).getEventsForYou(
            eventsForYouPageNumber: eventsPageNumber,
          );
    } else if (widget.eventType == EventType.yourEvent) {
      await ref.read(EventsViewModel.eventsProvider.notifier).getYourEvents(
            scope: ref.read(EventsViewModel.selectedScopeProvider),
            yourEventsPageNumber: eventsPageNumber,
          );
    } else if (widget.eventType == EventType.discover) {
      await _getCurrentLocation();

      await ref.read(EventsViewModel.eventsProvider.notifier).getDiscoverEvents(
            discoverEventsPageNumber: eventsPageNumber,
          );
    }
  }

  void _handlePagination() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLastPageEvents) {
        _getEvents();
      }
    });
  }

  bool get _isLastPageEvents {
    if (widget.eventType == EventType.forYou) {
      return ref.read(EventsViewModel.isLastEventsForYouPageProvider);
    } else if (widget.eventType == EventType.yourEvent) {
      return ref.read(EventsViewModel.isLastYourEventsPageProvider);
    } else if (widget.eventType == EventType.discover) {
      return ref.read(EventsViewModel.isLastDiscoverEventsPageProvider);
    } else {
      return true;
    }
  }
}
