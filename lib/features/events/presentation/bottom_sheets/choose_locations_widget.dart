import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/constants/enums/permission_type.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/shared_pref_manager.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/utils/location_util.dart';
import 'package:hauui_flutter/core/widgets/common/bottom_sheets/main_bottom_sheet.dart';
import 'package:hauui_flutter/core/widgets/common/bottom_sheets/permissions_bottom_sheet.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_divider_horizontal.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';
import 'package:hauui_flutter/features/events/presentation/screens/events_view_model.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class ChooseLocationsWidget extends ConsumerStatefulWidget {
  const ChooseLocationsWidget({
    super.key,
    required this.address,
  });

  final String? address;

  @override
  ConsumerState<ChooseLocationsWidget> createState() => _ChooseLocationsWidgetState();
}

class _ChooseLocationsWidgetState extends ConsumerState<ChooseLocationsWidget> with WidgetsBindingObserver {
  final _locationUtil = const LocationUtil();
  bool _shouldRecallGetCurrentLocation = false;
  StreamSubscription<ServiceStatus>? _locationServiceStatusStreamSubscription;

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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainBottomSheet(
        title: LocaleKeys.chooseLocations.tr(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimens.spacingNormal),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomImage.svg(
                    src: AppSvg.icLocation,
                    height: AppDimens.widgetDimen16pt,
                    width: AppDimens.widgetDimen16pt,
                    color: AppColors.vividCyan,
                  ),
                  const SizedBox(width: AppDimens.widgetDimen12pt),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.yourSelectedLocation.tr(),
                        style: TextStyleManager.semiBold(
                          size: AppDimens.textSize14pt,
                        ),
                      ),
                      const SizedBox(height: AppDimens.widgetDimen8pt),
                      Text(
                        widget.address ?? '-',
                        textAlign: TextAlign.center,
                        style: TextStyleManager.regular(
                          size: AppDimens.textSize14pt,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const CustomDividerHorizontal(),
            InkWell(
              onTap: () async => _getCurrentLocation(),
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spacingNormal),
                child: Text(
                  LocaleKeys.chooseCurrentLocation.tr(),
                  style: TextStyleManager.semiBold(
                    size: AppDimens.textSize14pt,
                  ),
                ),
              ),
            ),
            const CustomDividerHorizontal(),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(RoutesNames.changeCityRoute).whenComplete(
                      () => Navigator.of(context).pop(),
                    );
              },
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spacingNormal),
                child: Text(
                  LocaleKeys.chooseAntherLocation.tr(),
                  style: TextStyleManager.semiBold(
                    size: AppDimens.textSize14pt,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> _getCurrentLocation() async {
    await _locationUtil.getCurrentLocation(
      onLocationGranted: (latLng) => _onLocationGranted(latLng: latLng),
      onLocationDeniedForever: _onLocationDeniedForever,
      onLocationServiceDisabled: _onLocationServiceDisabled,
    );
  }

  void _onLocationGranted({required LatLng latLng}) {
    SharedPreferencesManager.saveData(key: AppConstants.prefLatLongEvent, value: latLng.toJson().toString());

    final lat = ref.read(EventsViewModel.latitudeProvider.notifier).update((state) => state = latLng.latitude);
    final lng = ref.read(EventsViewModel.longitudeProvider.notifier).update((state) => state = latLng.longitude);

    ref.read(EventsViewModel.eventsProvider.notifier).getDiscoverEvents(
          discoverEventsPageNumber: ApiConstants.firstPage,
          lat: ref.read(EventsViewModel.latitudeProvider),
          long: ref.read(EventsViewModel.longitudeProvider),
        );
    logger.i('Location is granted: $lat, $lng');

    Navigator.of(navigatorKey.currentContext!).pop();
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
}
